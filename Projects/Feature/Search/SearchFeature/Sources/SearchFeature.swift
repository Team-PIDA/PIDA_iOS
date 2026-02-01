//
//  SearchFeature.swift
//
//  Search
//
//  Created by JiYeon
//

import Shared
import ComposableArchitecture
import SearchFeatureInterface
import SearchClient
import FlowerSpotClient
import AnalyticsClient

extension SearchFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.searchClient) var searchClient
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    @Dependency(\.analyticsClient) var analyticsClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .binding(\.searchWord):
        let searchQuery = state.searchWord
        if searchQuery.isEmpty {
          state.showRecentList = true
          return .send(.updateSearchResults(state.recentList))
        } else {
          // 첫 입력 시 search_input 이벤트 트래킹
          if state.showRecentList {
            analyticsClient.track(SearchEvent.input)
          }
          state.showRecentList = false
          return .send(.searchItem(searchQuery))
        }

      case .onAppear:
        // search_start 이벤트는 fetchRecentResult 완료 후 트래킹
        return .concatenate(
          .send(.configureSearchList),
          .send(.searchBarFocused(true)),
          .send(.fetchRecentResult)
        )

      case .configureSearchList:
        if state.searchWord.isEmpty {
          state.showRecentList = true
          return .none
        } else {
          state.showRecentList = false
          return .send(.searchItem(state.searchWord))
        }

      // MARK: - Search
      case let .searchItem(searchQuery):
        return searchItem(with: searchQuery)

      case let .updateSearchResults(results):
        state.searchList = results
        // 검색 결과 없음 트래킹 (최근 검색 목록이 아니고, 결과가 비어있을 때)
        if !state.showRecentList && results.isEmpty && !state.searchWord.isEmpty {
          analyticsClient.track(
            SearchEvent.noResultViewed(
              keywordLength: state.searchWord.count,
              resultType: .landmark
            )
          )
        }
        return .none

      case .fetchRecentResult:
        return fetchRecentResult(keyword: state.searchWord)

      case let .storeRecentResult(item):
        state.recentList = item
        // search_start 이벤트 트래킹
        analyticsClient.track(
          SearchEvent.start(
            hasRecentSearches: !item.isEmpty,
            recentSearchesCount: item.count,
            entryPoint: "map"
          )
        )
        return .none

      case let .fetchSearchResult(result):
        return .send(.delegate(.selectResult(result)))

      case let .searchBarFocused(isFocused):
        state.isFocused = isFocused
        return .none

      case let .initialSearchBar(text):
        state.searchWord = text ?? ""
        return .none
        
      case let .selectResult(item):
        // 최근 검색어 클릭 or 자동완성 클릭 트래킹
        if state.showRecentList {
          analyticsClient.track(SearchEvent.recentSearchClicked)
        } else {
          let resultType: SearchEvent.ResultType = item.searchType == .region ? .region : .landmark
          analyticsClient.track(SearchEvent.suggestionClicked(resultType: resultType))
        }

        switch item.searchType {
        case .region:
          if let name = item.streetName, let coord = item.coord {
            return .send(
              .delegate(
                .selectRegionResult(.init(name: name, coordinate: coord))
              )
            )
          } else { return .none }
        case .street:
          return fetchSelectedDetailInfo(item: item)
        }
        
      // MARK: - Delegate
      
      case .dismiss:
        return .concatenate(
          .send(.searchBarFocused(false)),
          .send(.delegate(.dismiss))
        )

      case .binding, .delegate:
        return .none
      }
    }
  }
}

extension SearchFeature.Core {
  
  private func fetchRecentResult(keyword: String) -> Effect<Action> {
    return .run { send in
      do {
        let recent = try await searchClient.fetchRecentSearch()
        await send(.storeRecentResult(recent))
        if keyword.isEmpty {
          await send(.updateSearchResults(recent))
        }
      }
    }
  }
  
  private func searchItem(with searchQuery: String) -> Effect<Action> {
    return .run { send in
      do {
        var data = try await searchClient.getSearchListFromCache()
        if data.isEmpty {
          print("캐시 복구")
          try await flowerSpotClient.fetchAllFlowerAddress()
          data = try await searchClient.getSearchListFromCache()
        }
        let scoredResults = try data.map { flowerSpot -> (flower: SearchListCellEntity, score: Int) in
          let addressScore = try searchClient.calculateSimilarityScore(
            text: flowerSpot.address,
            query: searchQuery
          ) * 2
          let streetScore = try searchClient.calculateSimilarityScore(
            text: flowerSpot.streetName,
            query: searchQuery
          )
          let totalScore = addressScore + streetScore
          return (flowerSpot, totalScore)
        }
        let filteredResults = scoredResults
          .filter { $0.score > 0 }
          .sorted { $0.score > $1.score }
          .prefix(20)
          .map { $0.flower }
        await MainActor.run { send(.updateSearchResults(filteredResults)) }
      } catch let error as NetworkError {
        print(error.errorDescription)
      } catch let error as FoundationError {
        print(error.errorDescription)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  private func fetchSelectedDetailInfo(item: SearchListCellEntity) -> Effect<Action> {
    return .run { send in
      do {
        let detail = try await flowerSpotClient.getFlowerSpotDetail(id: item.id)
        try await searchClient.saveRecentSearchItem(item: item)
        await MainActor.run {
          send(.searchBarFocused(false))
          send(.fetchSearchResult(detail))
        }
      } catch let error as NetworkError {
        print(error.errorDescription)
      } catch let error as FoundationError {
        print(error.errorDescription)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

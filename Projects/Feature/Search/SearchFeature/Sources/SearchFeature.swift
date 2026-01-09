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
import Shared

extension SearchFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.searchClient) var searchClient
    @Dependency(\.flowerSpotClient) var flowerSpotClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .binding(\.searchWord):
        let searchQuery = state.searchWord
        if searchQuery.isEmpty {
          state.showRecentList = true
          return .send(.updateSearchResults(state.recentList))
        } else {
          state.showRecentList = false
          return .send(.searchItem(searchQuery))
        }

      case .onAppear:
        return .run { send in
          await MainActor.run {
            send(.configureSearchList)
            send(.searchBarFocused(true))
            send(.fetchRecentResult)
          }
        }

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
        return .none

      case .fetchRecentResult:
        return .run { [searchKeyword = state.searchWord] send in
          do {
            let recent = try await searchClient.fetchRecentSearch()
            await send(.storeRecentResult(recent))
            if searchKeyword.isEmpty {
              await send(.updateSearchResults(recent))
            }
          }
        }

      case let .storeRecentResult(item):
        state.recentList = item
        return .none

      case let .fetchSearchResult(result):
        return .send(.delegate(.selectRegionResult(result)))

      case let .searchBarFocused(isFocused):
        state.isFocused = isFocused
        return .none

      case let .initialSearchBar(text):
        state.searchWord = text ?? ""
        return .none
        
      case let .selectResult(item): // TODO: - 선택한 타입(리전, 거리)에 따라 분기처리 필요
        return fetchSelectedDetailInfo(item: item)

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

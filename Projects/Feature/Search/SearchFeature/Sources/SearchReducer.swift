//
//  SearchReducer.swift
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


extension SearchReducer {
  public init() {
    @Dependency(\.calculateSimilarityScoreUseCase) var calculateScoreUseCase
    @Dependency(\.fetchAllFlowerAddressUseCase) var fetchAllFlowerAddressUseCase
    @Dependency(\.getSearchListFromCacheUseCase) var getSearchListFromCacheUseCase
    @Dependency(\.getFlowerSpotDetailUseCase) var getFlowerSpotDetailUseCase
    @Dependency(\.saveRecentSearchItemUseCase) var saveRecentSearchItemUseCase
    @Dependency(\.fetchRecentSearchItemUseCase) var fetchRecentSearchItemUseCase
    
    let searchReducer = Reduce<State, Action> { state, action in
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
        return .run { send in
          do {
            var cache = try await getSearchListFromCacheUseCase.execute()
            if cache.isEmpty { // 캐시가 날라갔으면!
              print("캐시 복구")
              try await fetchAllFlowerAddressUseCase.execute()
              cache = try await getSearchListFromCacheUseCase.execute()
            }
            let scoredResults = cache.map { flowerSpot -> (flower: SearchListCellEntity, score: Int) in
              let addressScore = calculateScoreUseCase.execute(flowerSpot.address ?? "", query: searchQuery) * 2
              let streetScore = calculateScoreUseCase.execute(flowerSpot.streetName ?? "", query: searchQuery)
              let totalScore = addressScore + streetScore
              return (flowerSpot, totalScore)
            }
            let filteredResults = scoredResults
              .filter { $0.score > 0 } // 검색어와 일치하는 부분이 있는 항목만 선택
              .sorted { $0.score > $1.score } // 점수 높은 순으로 정렬
              .prefix(20) // 상위 20개만 선택
              .map { $0.flower } // 원본 데이터만 추출
            await MainActor.run {
              send(.updateSearchResults(filteredResults))
            }
          } catch let error as NetworkError {
            print(error.errorDescription)
          } catch let error as FoundationError {
            print(error.errorDescription)
          } catch {
            print(error.localizedDescription)
          }
        }
        
      case let .updateSearchResults(results):
        state.searchList = results
        return .none
        
      case .fetchRecentResult:
        return .run { [searchKeyword = state.searchWord] send in
          do {
            let recent = try await fetchRecentSearchItemUseCase.execute()
            
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
        return .run { send in
          await MainActor.run {
            send(.delegate(.selectResult(result)))
          }
        }
        
      case let .searchBarFocused(isFocused):
        state.isFocused = isFocused
        return .none
      case let .initialSearchBar(text): // 서치바 초기화
        state.searchWord = text ?? ""
        return .none
        
      // MARK: - Delegate
        
      case let .selectResult(item):
        return .run { send in
          do {
            let detail = try await getFlowerSpotDetailUseCase.execute(id: item.id)
            try await saveRecentSearchItemUseCase.execute(spot: item)
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
      case .dismiss:
        return .run { send in
          await MainActor.run {
            send(.searchBarFocused(false))
            send(.delegate(.dismiss))
          }
        }
      case .binding, .delegate:
        return .none
      }
    }
    
    self.init(reducer: searchReducer)
  }
}

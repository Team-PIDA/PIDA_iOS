//
//  SearchReducer.swift
//
//  Search
//
//  Created by JiYeon
//
import Foundation
import SearchFeatureInterface
import ComposableArchitecture
import SearchDomainInterface
import Utility

extension SearchReducer {
  public init() {
    @Dependency(\.calculateSimilarityScoreUseCase) var calculateScoreUseCase
    @Dependency(\.getSearchListFromCacheUseCase) var getSearchListFromCacheUseCase
    
    let searchReducer = Reduce<State, Action> { state, action in
      switch action {
      case .binding(\.searchWord):
        let searchQuery = state.searchWord
        return .run { send in
          do {
            let cache = try await getSearchListFromCacheUseCase.execute()
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
      case .onAppear:
        return .run { send in
          await MainActor.run {
            send(.searchBarFocused(true))
          }
        }
        
      // MARK: - Search
        
      case let .searchBarFocused(isFocused):
        state.isFocused = isFocused
        return .none
      case let .initialSearchBar(text): // 서치바 초기화
        state.searchWord = text
        return .none
      case let .updateSearchResults(results):
        state.searchList = results
        return .none
        
      // MARK: - Delegate
        
      case let .selectResult(result):
        return .run { send in
          await MainActor.run {
            send(.searchBarFocused(false))
            send(.delegate(.selectResult(result)))
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

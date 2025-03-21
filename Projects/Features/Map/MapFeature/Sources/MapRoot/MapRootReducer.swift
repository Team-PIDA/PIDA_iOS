//
//  MapRootReducer.swift
//  MapDemo
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import MapFeatureInterface
import SearchFeatureInterface

extension MapRootReducer {
  public init(
    searchReducer: SearchReducer
  ) {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
        
      case let .presentSearch(isShow):
        state.isShowSearch = isShow
        return .none
      // map -> search
      case .map(.delegate(.presentToSearch)):
        return .run { send in
          await MainActor.run {
            send(.presentSearch(true))
          }
        }
      // 검색 후 main에서 뒤로가기 시 search의 searchbar 비우기
      case .map(.delegate(.resetSearchView)):
        return .run { send in
          await MainActor.run {
            send(.search(.initialSearchBar("")))
          }
        }
      // search dismiss
      case .search(.delegate(.dismiss)):
        return .run { send in
          await MainActor.run {
            send(.presentSearch(false))
          }
        }
        
      // search dismiss with result
      case let .search(.delegate(.selectResult(result))):
        return .run { send in
          await MainActor.run {
            send(.map(.showSearchResult(result)))
            send(.presentSearch(false))
          }
        }
      // map -> setting
      case .map(.delegate(.pushToSetting)):
        state.path.append(.setting)
        return .none
        
      case .binding, .map, .search:
        return .none
      }
    }
    self.init(
      reducer: reducer,
      mapReducer: .init(),
      searchReducer: searchReducer
    )
  }
}

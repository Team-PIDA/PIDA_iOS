//
//  MapSearchFeature.swift
//  MapFeature
//
//  Created by Jiyeon on 1/21/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import MapFeatureInterface
import Shared

extension MapSearchFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }
  
  struct Core: Reducer {
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
        
      case let .setSearchBarText(text):
        state.searchText = text
        return .none
        
      case .resetSearchBar:
        return .concatenate(
          .send(.showSearchResult(nil)),
          .send(.setSearchBarText(nil))
        )
        
      case let .showSearchResult(result):
        state.searchResult = result
        if result != nil {
          state.detailRoot = .search
        }
        return .send(.delegate(.showSearchResult(result)))
        
      case .presentToSearch:
        return .send(.delegate(.presentToSearch(state.searchText)))
        
      case let .showRegionList(result):
        state.isShowRegionList = result != nil
        if let result = result {
          state.regionResult = result
        } else {
          state.regionSheetDetent = .medium
        }
        return .send(.delegate(.showSearchRegionList(result)))
        
      case .hideRegionList:
        if state.isShowRegionList { // 리전 검색 결과 리스트에서 마커 탭 시 바텀시트 정리
          state.isShowRegionList = false
          state.detailRoot = .region
        }
        return .none
        
      case .changeRegionSheetDetent:
        if state.isShowRegionList {
          state.regionSheetDetent = .low
        }
        return .none
        
      case .searchBackButtonTapped:
        return .concatenate(
          .send(.handleSearchBackNavigation),
          .send(.resetSearchBar),
          .send(.delegate(.resetMarkerTapped))
        )
        
      case .handleSearchBackNavigation:
        switch state.detailRoot {
        case .region:
          state.detailRoot = nil
          return .concatenate(
            .send(.showRegionList(data: state.regionResult)),
            .send(.delegate(.dismissFlowerSpotDetil))
          )
        case .search:
          state.detailRoot = nil
          return .send(.presentToSearch)
        case nil:
          if state.isShowRegionList {
            state.regionResult = nil
            return .concatenate(
              .send(.showRegionList(data: nil)),
              .send(.presentToSearch)
            )
          }
        }
        return .none
        
      case .binding, .delegate: return .none
      }
    }
  }
}

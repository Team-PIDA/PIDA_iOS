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
        if let _ = result {
          state.currentNavigation = .flowerDetail(.fromSearch)
        }
        return .send(.delegate(.showSearchResult(result)))
        
      case .presentToSearch:
        return .send(.delegate(.presentToSearch(state.searchText)))
        
      case let .showRegionList(result):
        state.isShowRegionList = result != nil
        if let result = result {
          state.regionResult = result
          state.currentNavigation = .regionList
        } else {
          state.regionSheetDetent = .medium
        }
        return .send(.delegate(.showSearchRegionList(result)))
        
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
        switch state.currentNavigation {
        case .flowerDetail(.fromSearch):
          // 검색 → 상세 → 뒤로 = 검색화면
          state.currentNavigation = .map
          return .send(.presentToSearch)
          
        case .flowerDetail(.fromRegionList):
          // 리전리스트 → 상세 → 뒤로 = 리전리스트 복원
          state.currentNavigation = .regionList
          return .concatenate(
            .send(.showRegionList(data: state.regionResult)),
            .send(.delegate(.dismissFlowerSpotDetail))
          )
          
        case .regionList:
          // 리전리스트 → 뒤로 = 검색화면
          state.currentNavigation = .map
          state.regionResult = nil
          return .concatenate(
            .send(.showRegionList(data: nil)),
            .send(.presentToSearch)
          )
          
        case .map:
          return .none
        }
        
      case .setNavigationFromRegionList:
        state.currentNavigation = .flowerDetail(.fromRegionList)
        return .none
        
      case .binding, .delegate: return .none
      }
    }
  }
}

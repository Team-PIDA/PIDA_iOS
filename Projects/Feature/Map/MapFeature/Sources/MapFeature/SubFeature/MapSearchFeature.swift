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
        if let result = result {
          state.currentNavigation = .flowerDetail(.fromSearch(result))
        }
        return .send(.delegate(.showSearchResult(result)))
        
      case .presentToSearch:
        return .send(.delegate(.presentToSearch(state.searchText)))
        
      case let .showRegionList(result):
        state.isShowRegionList = result != nil
        if let result = result {
          state.regionResult = result
          state.currentNavigation = .regionList(result)
        } else {
          state.regionSheetDetent = .medium
        }
        return .send(.delegate(.showSearchRegionList(result)))
        
      case .hideRegionList:
        if state.isShowRegionList { // 리전 검색 결과 리스트에서 마커 탭 시 바텀시트 정리
          state.isShowRegionList = false
          if case .regionList(let region) = state.currentNavigation {
            state.currentNavigation = .flowerDetail(.fromRegionList(region))
          }
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
        switch state.currentNavigation {
        case .flowerDetail(.fromSearch):
          // 검색 → 상세 → 뒤로 = 검색화면
          state.currentNavigation = .map
          return .send(.presentToSearch)
          
        case .flowerDetail(.fromRegionList(let region)):
          // 리전리스트 → 상세 → 뒤로 = 리전리스트 복원
          state.currentNavigation = .regionList(region)
          return .concatenate(
            .send(.showRegionList(data: region)),
            .send(.delegate(.dismissFlowerSpotDetil))
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
        if let regionResult = state.regionResult {
          state.currentNavigation = .flowerDetail(.fromRegionList(regionResult))
        }
        return .none
        
      case .binding, .delegate: return .none
      }
    }
  }
}

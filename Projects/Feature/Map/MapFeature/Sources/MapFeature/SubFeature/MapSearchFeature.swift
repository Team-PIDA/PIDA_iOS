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
        return .concatenate(
          .send(.delegate(.showSearchResult(result))),
          result != nil ? .send(.showRegionList(data: nil)) : .none // 리전 리스트 화면 정리
        )
        
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
        return .concatenate(
          .send(.delegate(.showSearchRegionList(result))),
          result != nil ? .send(.delegate(.dismissFlowerSpotDetail)) : .none // 디테일 화면 닫기
        )
        
      case .changeRegionSheetDetent:
        if state.isShowRegionList {
          state.regionSheetDetent = .low
        }
        return .none
        
      case .searchBackButtonTapped:
        let isFromCategory = state.currentNavigation == .flowerDetail(.fromCategory)
        return .concatenate(
          .send(.handleSearchBackNavigation),
          isFromCategory ? .none : .send(.resetSearchBar),
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
          
        case .flowerDetail(.fromCategory):
          // 카테고리 → 상세 → 뒤로 = 카테고리 복원
          state.currentNavigation = .category
          return .send(.delegate(.restoreCategoryList))

        case .category:
          // 카테고리 → 뒤로 = 기본 지도 화면
          state.currentNavigation = .map
          return .send(.delegate(.resetCategorySelection))

        case .map:
          return .none
        }
        
      case .setNavigationFromRegionList:
        state.currentNavigation = .flowerDetail(.fromRegionList)
        return .none

      case .setNavigationFromCategory:
        state.currentNavigation = .flowerDetail(.fromCategory)
        return .none

      case .binding, .delegate: return .none
      }
    }
  }
}

//
//  MapFeature.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import Shared
import ComposableArchitecture
import MapFeatureInterface
import CategoryFeatureInterface
import FlowerSpotClient
import FlowerSpotDetailFeatureInterface
import SearchRegionListFeatureInterface
import AnalyticsClient
import DesignKit

extension MapFeature {
  public init(
    location: Reduce<LocationFeature.State, LocationFeature.Action>,
    mapSearch: Reduce<MapSearchFeature.State, MapSearchFeature.Action>,
    category: Reduce<CategoryFeature.State, CategoryFeature.Action>,
    flowerSpotDetail: FlowerSpotDetailFeature,
    searchRegionList: SearchRegionListFeature,
    categoryListFeature: CategoryListFeature
  ) {
    self.init(
      reducer: Reduce(Core()),
      location: location,
      mapSearch: mapSearch,
      category: category,
      flowerSpotDetail: flowerSpotDetail,
      searchRegionList: searchRegionList,
      categoryListFeature: categoryListFeature
    )
  }
  
  struct Core: Reducer {
    @Dependency(\.flowerSpotClient) var flowerSpot
    @Dependency(\.openURL) var openURL
    @Dependency(\.analyticsClient) var analyticsClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
        
      case let .showToastView(message, buttonLabel):
        state.toastMessage = message
        state.toastLabel = buttonLabel
        return .none
        
      case .moveToReportURL:
        analyticsClient.track(MapEvent.reportClicked)
        return .run { send in
          if let url = ExternalURL.report {
            await openURL(url)
          }
        }
        
      case .viewDidAppear:
        state.isViewAppeared = true
        return .send(.category(.fetchCategoryList))
        
      case let .requestMapBounds(isRequest):
        state.shouldRequestInitialBounds = true
        state.researchButtonEnable = false
        if isRequest {
          analyticsClient.track(MapEvent.researchClicked(currentPage: "map"))
          state.spots.removeAll()
          return .send(.addMapAction(.requestBounds))
        }
        return .none
        
      case let .receiveMapBounds(coordinates):
        if state.category.selectedCategory == .all {
          return .send(.location(.fetchFlowers(coordinates)))
        } else {
          return .send(.category(.fetchCategorySpots(coordinates)))
        }
        
        // 마커 탭 시, 디테일정보 불러오기 및 바텀시트 on
      case let .markerTapped(id):
        guard let id = id else {
          state.mapActions.append(.deletePath)
          state.flowerSpotDetail = nil  // 바텀시트 닫기
          return .none
        }
        // flowerSpotDetail State 설정 (userLocation 전달하여 distance 계산 가능하게)
        state.flowerSpotDetail = .init(userLocation: state.userLocation)

        let isFromCategory = state.mapSearch.currentNavigation == .category
        if isFromCategory {
          state.category.isShowCategoryList = false  // CategoryList 바텀시트 숨기기 (State는 유지)
        }

        return .concatenate(
          .send(.mapSearch(.showRegionList(data: nil))),
          isFromCategory
            ? .send(.mapSearch(.setNavigationFromCategory))
            : .send(.mapSearch(.setNavigationFromRegionList)),
          .send(.fetchPathLines(id)),
          .send(.flowerSpotDetail(.requestDetailInfo(id)))
        )
        
      case let .fetchPathLines(id):
        if let data = state.spots[id] {
          state.selectedPathLines = data.path
          state.mapActions.append(.drawPath(data, data.path))
        } else {
          state.selectedPathLines = []
        }
        return .none
      
      case let .fetchDetailInfo(id):
        // flowerSpotDetail State가 nil이면 초기화 (이미 열려있으면 유지)
        if state.flowerSpotDetail == nil {
          state.flowerSpotDetail = .init(userLocation: state.userLocation)
        }
        return .concatenate(
          .send(.fetchPathLines(id)),
          .send(.flowerSpotDetail(.fetchDetailInfo(id)))
        )
        
        // MARK: - MapSearch Delegate Action
        
      case let .mapSearch(.delegate(action)):
        switch action {
        case let .showSearchResult(result):
          if result != nil {
            // flowerSpotDetail State 설정 (userLocation 전달하여 distance 계산 가능하게)
            state.flowerSpotDetail = .init(userLocation: state.userLocation)
          } else {
            state.flowerSpotDetail = nil
          }
          return showSearchResult(result: result)
          
        case let .presentToSearch(keyword):
          return .send(.delegate(.presentToSearch(keyword)))
          
        case let .showSearchRegionList(result):
          if let result = result {
            state.searchRegionList = .init(region: result)
            return showSearchRegionResult(name: result.name, coord: result.coordinate)
          } else {
            state.searchRegionList = nil
            return .none
          }
          
        case .resetMarkerTapped:
          return .send(.markerTapped(id: nil))

        case .dismissFlowerSpotDetail:
          state.flowerSpotDetail = nil
          return .none

        case .resetCategorySelection:
          state.category.isShowCategoryList = false
          state.categoryList = nil
          return .send(.category(.resetToAll))

        case .restoreCategoryList:
          state.category.isShowCategoryList = true
          state.category.categoryListDetent = .medium
          state.flowerSpotDetail = nil
          state.mapActions.append(.clearFocus)
          return .none
        }
        
        // MARK: - Alert
        
      case let .presentAlert(type):
        state.alertType = type
        return .none
        
      case .alertCancelTapped:
        return .send(.clearAlertState)
        
      case .alertAcceptTapped(.locationPermission):
        return .run { send in
          if let url = URL(string: UIApplication.openSettingsURLString) {
            await openURL(url)
            await send(.clearAlertState)
          }
        }
        
      case .clearAlertState:
        state.alertType = nil
        return .none
        
        // MARK: - LocationFeature Delegate
        
      case let .location(.delegate(action)):
        switch action {
        case let .storeFlowerData(data):
          state.spots.removeAll()
          data.forEach {
            state.spots[$0.id] = $0.asMapSpot
          }
          return .concatenate(
            .send(.addMapAction(.updateMarkers(state.spots))),
            state.searchRegionList != nil ? .send(.searchRegionList(.storeFlowerSpots(data))) : .none
          )
          
        case let .storeUserLocation(location):
          state.userLocation = location
          state.location.userLocation = location
          
          // 초기 지도 로드 시 한번만 실행
          if shouldTriggerInitialMapLoad(state: state) {
            state.isInitialMapLoadCompleted = true
            return .concatenate(
              .send(.requestMapBounds(true)),
              .send(.delegate(.mapDidLoad))
            )
          }
          return .none
          
        case let .showToastView(message, label):
          return .send(.showToastView(message: message, buttonLabel: label))
          
        case let .presentAlert(type):
          return .send(.presentAlert(type: type))
          
        case let .moveToLocation(location):
          state.mapActions.append(.moveToUserLocation(location))
          return .none
        }
        
        // MARK: - Delegate

      case .pushToSetting:
        return .send(.delegate(.pushToSetting))

      // MARK: - FlowerSpotDetailFeature 처리

      case let .flowerSpotDetail(.delegate(action)):
        switch action {
        case .dismiss:
          // 바텀시트 닫기: Optional State를 nil로 설정
          let isFromCategory = state.mapSearch.currentNavigation == .flowerDetail(.fromCategory)
          state.flowerSpotDetail = nil
          if isFromCategory {
            state.spots.removeAll()
            state.mapActions.append(.clearFocus)
            state.mapActions.append(.updateMarkers(state.spots))  // updateMarkers([]) → currentFlowerPositions 리셋 트리거
            state.mapSearch.currentNavigation = .category
            state.category.isShowCategoryList = true
          } else {
            state.mapActions.append(.deletePath)
          }
          return .none

        case let .presentToBlooming(id, streetName, distance):
          return .send(.delegate(.presentToBlooming(id: id, streetName: streetName, distance: distance)))

        case let .presentToLogin(id):
          return .send(.delegate(.presentToLogin(id: id)))

        case let .showOnMap(flowerSpot):
          state.mapSearch.searchResult = flowerSpot
          return .send(.location(.moveLocation(flowerSpot.pinPoint)))

        case let .didUpdateFlowerSpot(item):
          guard state.spots[item.id] != nil else { return .none }
          state.spots[item.id] = item.asMapSpot
          return .none
          
        case let .updateMarkerStatus(bloomStatus):
          return .send(.addMapAction(.updateMarkerStatus(bloomStatus)))
        }
        
      case let .searchRegionList(.delegate(action)):
        switch action {
        case let .showFlowerSpotDetail(data):
          return .concatenate(
            .send(.addMapAction(.changeActiveMarker(data.asMapSpot))),
            .send(.markerTapped(id: data.id))
          )
        }

      case .flowerSpotDetail:
        return .none
        
      case let .addMapAction(action):
        state.mapActions.append(action)
        return .none
        
        // MARK: - CategoryFeature Delegate Action
        
      case let .category(.delegate(action)):
        switch action {
        case let .tapCategory(category):
          state.mapSearch.currentNavigation = .category
          state.categoryList = .init(categoryItem: category)
          state.category.isShowCategoryList = true
          state.flowerSpotDetail = nil
          state.mapActions.append(.deletePath)
          return .send(.mapSearch(.setSearchBarText(category.title)))

        case .resetCategory:
          state.mapSearch.currentNavigation = .map
          state.category.isShowCategoryList = false
          state.categoryList = nil
          state.spots.removeAll()
          return .concatenate(
            .send(.mapSearch(.resetSearchBar)),
            .send(.addMapAction(.updateMarkers(state.spots)))
          )

        case let .didFetchCategoryItems(categoryItemList):
          state.spots.removeAll()
          let spotType = categoryItemList.categoryType.spotType
          categoryItemList.list.forEach {
            state.spots[$0.id] = MapSpotEntity(
              id: $0.id,
              pinPoint: $0.pinPoint,
              path: $0.path,
              type: spotType,
              bloomStatus: BloomStatus(rawValue: $0.bloomingStatus) ?? .notBloomed
            )
          }
          return .concatenate(
            .send(.addMapAction(.updateMarkers(state.spots))),
            .send(.categoryList(.storeCategoryItems(categoryItemList)))
          )
          
        case .requestMapBounds:
          return .send(.requestMapBounds(true))
        }
        
        // MARK: - CategoryListFeature Delegate Action

      case .categoryList(.delegate):
        return .none

      case .binding, .delegate, .alertAcceptTapped, .location, .searchRegionList, .mapSearch, .category, .categoryList:
        return .none
        
      }
    }
  }
}

extension MapFeature.Core {
  /// 초기 지도 로드 이벤트 트리거 조건 확인
  private func shouldTriggerInitialMapLoad(state: State) -> Bool {
    return state.isViewAppeared && !state.isInitialMapLoadCompleted
  }
  
  private func showSearchResult(result: FlowerSpotEntity?) -> Effect<Action> {
    return .run { send in
      if let result = result {
        await send(.mapSearch(.setSearchBarText(result.streetName)))
        await send(.location(.moveLocation(result.pinPoint)))
        await send(.addMapAction(.showFocus(result.asMapSpot)))
        await send(.flowerSpotDetail(.requestDetailInfo(result.id)))
      } else {
        await send(.addMapAction(.clearFocus))
      }
    }
  }
  
  private func showSearchRegionResult(name: String, coord: Coordinate) -> Effect<Action> {
    return .run { send in
      await send(.markerTapped(id: nil))
      await send(.mapSearch(.setSearchBarText(name)))
      await send(.location(.moveLocation(coord)))
      await send(.location(.fetchFlowersInRadius(coordinate: coord, radiusInKm: 1.0)))
    }
  }

}

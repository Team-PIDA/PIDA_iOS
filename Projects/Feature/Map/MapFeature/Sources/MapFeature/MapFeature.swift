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


extension MapFeature {
  public init(
    location: Reduce<LocationFeature.State, LocationFeature.Action>,
    mapSearch: Reduce<MapSearchFeature.State, MapSearchFeature.Action>,
    category: Reduce<CategoryFeature.State, CategoryFeature.Action>,
    flowerSpotDetail: FlowerSpotDetailFeature,
    searchRegionList: SearchRegionListFeature
  ) {
    self.init(
      reducer: Reduce(Core()),
      location: location,
      mapSearch: mapSearch,
      category: category,
      flowerSpotDetail: flowerSpotDetail,
      searchRegionList: searchRegionList
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
        return .none
        
      case let .requestMapBounds(isRequest):
        state.shouldRequestInitialBounds = true
        state.researchButtonEnable = false
        if isRequest {
          analyticsClient.track(MapEvent.researchClicked(currentPage: "map"))
          state.flowerSpots.removeAll()
          return .send(.addMapAction(.requestBounds))
        }
        return .none
        
        // 마커 탭 시, 디테일정보 불러오기 및 바텀시트 on
      case let .markerTapped(id):
        guard let id = id else {
          state.mapActions.append(.deletePath)
          state.flowerSpotDetail = nil  // 바텀시트 닫기
          return .none
        }
        // flowerSpotDetail State 설정 (userLocation 전달하여 distance 계산 가능하게)
        state.flowerSpotDetail = .init(userLocation: state.userLocation)
        
        return .concatenate(
          .send(.mapSearch(.showRegionList(data: nil))),
          .send(.mapSearch(.setNavigationFromRegionList)),
          .send(.fetchPathLines(id)),
          .send(.flowerSpotDetail(.requestDetailInfo(id)))
        )
        
      case let .fetchPathLines(id):
        if let data = state.flowerSpots[id] {
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
          state.flowerSpots.removeAll()
          data.forEach {
            state.flowerSpots[$0.id] = $0
          }
          return .concatenate(
            .send(.addMapAction(.updateMarkers(state.flowerSpots))),
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
          state.flowerSpotDetail = nil
          state.mapActions.append(.deletePath)
          return .none

        case let .presentToBlooming(id, streetName, distance):
          return .send(.delegate(.presentToBlooming(id: id, streetName: streetName, distance: distance)))

        case let .presentToLogin(id):
          return .send(.delegate(.presentToLogin(id: id)))

        case let .showOnMap(flowerSpot):
          state.mapSearch.searchResult = flowerSpot
          return .send(.location(.moveLocation(flowerSpot.pinPoint)))

        case let .didUpdateFlowerSpot(item):
          let existData = state.flowerSpots[item.id]
          if let existData = existData,
             item.bloomingStatus != existData.bloomingStatus {
            state.flowerSpots[item.id] = item
          }
          return .none
          
        case let .updateMarkerStatus(bloomStatus):
          return .send(.addMapAction(.updateMarkerStatus(bloomStatus)))
        }
        
      case let .searchRegionList(.delegate(action)):
        switch action {
        case let .showFlowerSpotDetail(data):
          return .concatenate(
            .send(.addMapAction(.changeActiveMarker(data))),
            .send(.markerTapped(id: data.id))
          )
        }

      case .flowerSpotDetail:
        return .none
        
      case let .addMapAction(action):
        state.mapActions.append(action)
        return .none
        
      case .category(.delegate):
        return .none

      case .binding, .delegate, .alertAcceptTapped, .location, .searchRegionList, .mapSearch, .category:
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
        await send(.addMapAction(.showFocus(result)))
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

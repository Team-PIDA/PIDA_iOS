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
import FlowerSpotClient
import FlowerSpotDetailFeatureInterface
import SearchRegionListFeatureInterface


extension MapFeature {
  public init(
    location: Reduce<LocationFeature.State, LocationFeature.Action>,
    mapSearch: Reduce<MapSearchFeature.State, MapSearchFeature.Action>,
    flowerSpotDetail: FlowerSpotDetailFeature,
    searchRegionList: SearchRegionListFeature
  ) {
    self.init(
      reducer: Reduce(Core()),
      location: location,
      mapSearch: mapSearch,
      flowerSpotDetail: flowerSpotDetail,
      searchRegionList: searchRegionList
    )
  }
  
  struct Core: Reducer {
    @Dependency(\.flowerSpotClient) var flowerSpot
    @Dependency(\.openURL) var openURL
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
        
      case let .showToastView(message, buttonLabel):
        state.toastMessage = message
        state.toastLabel = buttonLabel
        return .none
        
      case .moveToReportURL:
        return .run { send in
          if let url = ExternalURL.report {
            await openURL(url)
          }
        }
        
      case .viewDidAppear:
        state.isViewAppeared = true
        return .send(.fetchAllFlowerAddress)
        
      case let .requestMapBounds(isRequest):
        state.requestMapBound = isRequest
        state.researchButtonEnable = false
        return .none
        
      case .fetchAllFlowerAddress:
        return fetchAllFlowerAddress()
        
        // 마커 탭 시, 디테일정보 불러오기 및 바텀시트 on
      case let .markerTapped(id):
        guard let id = id else {
          state.isNeedDeleteMarker = true
          state.flowerSpotDetail = nil  // 바텀시트 닫기
          return .none
        }
        // flowerSpotDetail State 설정 (userLocation 전달하여 distance 계산 가능하게)
        state.flowerSpotDetail = .init(userLocation: state.userLocation)
        
        if state.isShowRegionList { // 리전 검색 결과 리스트에서 마커 탭 시 바텀시트 정리
          state.isShowRegionList = false
          state.detailRoot = .region
        }
        return .run { send in
          await send(.showRegionList(data: nil))
          await send(.fetchPathLines(id))
          await send(.flowerSpotDetail(.requestDetailInfo(id)))
        }
        
      case let .fetchPathLines(id):
        if let data = state.flowerSpots[id] {
          state.selectedPathLines = data.path
          state.isNeedDrawMarker = true
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
            state.detailRoot = .search
            // flowerSpotDetail State 설정 (userLocation 전달하여 distance 계산 가능하게)
            state.flowerSpotDetail = .init(userLocation: state.userLocation)
          } else {
            state.flowerSpotDetail = nil
          }
          return showSearchResult(result: result)
          
        case let .presentToSearch(keyword):
          return .send(.delegate(.presentToSearch(keyword)))
        }
        
        // MARK: - Search
        
      case let .showRegionList(result):
        state.isShowRegionList = result != nil
        if let result = result {
          state.regionResult = result
          state.searchRegionList = .init(region: result)
          return showSearchRegionResult(name: result.name, coord: result.coordinate)
        } else {
          state.regionSheetDetent = .medium
          state.searchRegionList = nil
          return .none
        }
        
      case .changeRegionSheetDetent:
        if state.isShowRegionList {
          state.regionSheetDetent = .low
        }
        return .none
        
      case .searchBackButtonTapped:
        return .concatenate(
          .send(.handleSearchBackNavigation),
          .send(.mapSearch(.resetSearchBar)),
          .send(.markerTapped(id: nil))
        )
        
      case .handleSearchBackNavigation:
        switch state.detailRoot {
        case .region:
          state.flowerSpotDetail = nil
          state.detailRoot = nil
          if let result = state.regionResult {
            return .send(.showRegionList(data: result))
          }
          return .none
        case .search:
          state.detailRoot = nil
          return .send(.mapSearch(.presentToSearch))
        case nil:
          if state.isShowRegionList {
            state.regionResult = nil
            return .concatenate(
              .send(.showRegionList(data: nil)),
              .send(.mapSearch(.presentToSearch))
            )
          }
        }
        return .none
        
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
          // SearchRegionListFeature가 활성화되어 있으면 데이터 전달
          if state.searchRegionList != nil {
            return .send(.searchRegionList(.storeFlowerSpots(data)))
          }
          return .none
          
        case let .storeUserLocation(location):
          state.userLocation = location
          state.location.userLocation = location
          return .none
          
        case let .showToastView(message, label):
          return .send(.showToastView(message: message, buttonLabel: label))
          
        case let .presentAlert(type):
          return .send(.presentAlert(type: type))
        }
        
        // MARK: - Delegate

      case .pushToSetting:
        return .send(.delegate(.pushToSetting))

      // MARK: - FlowerSpotDetailFeature Delegate 처리
      case let .flowerSpotDetail(.delegate(action)):
        switch action {
        case .dismiss:
          // 바텀시트 닫기: Optional State를 nil로 설정
          state.flowerSpotDetail = nil
          state.isNeedDeleteMarker = true
          return .none

        case let .presentToBlooming(id, streetName):
          return .send(.delegate(.presentToBlooming(id: id, streetName: streetName)))

        case let .presentToLogin(id):
          return .send(.delegate(.presentToLogin(id: id)))

        case let .showOnMap(flowerSpot):
          state.mapSearch.searchResult = flowerSpot // TODO: - 왜 저장하는지?
          return .send(.location(.moveLocation(flowerSpot.pinPoint)))
        }
        
      case let .searchRegionList(.delegate(action)):
        switch action {
        case let .showFlowerSpotDetail(data):
          state.detailRoot = .region
          return .concatenate(
            .send(.showRegionList(data: nil)),
            .send(.fetchDetailInfo(data.id)),
            .send(.location(.moveLocation(data.pinPoint)))
          )
        }

      case .flowerSpotDetail:
        return .none
        
      case .binding, .delegate, .alertAcceptTapped, .location, .searchRegionList, .mapSearch:
        return .none
        
      }
    }
  }
}

extension MapFeature.Core {
  private func fetchAllFlowerAddress() -> Effect<Action> {
    return .run { send in
      do {
        try await flowerSpot.fetchAllFlowerAddress()
      } catch let error as NetworkError {
        print(error.localizedDescription)
      } catch let error as FoundationError {
        print(error.localizedDescription)
      } catch {
        print(error.localizedDescription)
      }
      await send(.requestMapBounds(true))
      await send(.delegate(.mapDidLoad))
    }
  }
  
  private func showSearchResult(result: FlowerSpotEntity?) -> Effect<Action> {
    return .run { send in
      if let result = result {
        await send(.mapSearch(.setSearchBarText(result.streetName)))
        await send(.location(.moveLocation(result.pinPoint)))
        await send(.fetchPathLines(result.id))
        await send(.flowerSpotDetail(.requestDetailInfo(result.id)))
      }
    }
  }
  
  private func showSearchRegionResult(name: String, coord: Coordinate) -> Effect<Action> {
    return .run { send in
      await send(.mapSearch(.setSearchBarText(name)))
      await send(.location(.moveLocation(coord)))
      await send(.location(.fetchFlowersInRadius(coordinate: coord, radiusInKm: 1.0)))
    }
  }
}

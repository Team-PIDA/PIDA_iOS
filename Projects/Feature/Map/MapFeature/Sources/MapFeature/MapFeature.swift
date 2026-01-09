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
    flowerSpotDetail: FlowerSpotDetailFeature,
    searchRegionList: SearchRegionListFeature
  ) {
    self.init(
      reducer: Reduce(Core()),
      location: location,
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
        return .run { send in
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
        
        // MARK: - Search
        
      case let .showSearchResult(result):
        state.searchResult = result
        if result != nil {
          // flowerSpotDetail State 설정 (userLocation 전달하여 distance 계산 가능하게)
          state.flowerSpotDetail = .init(userLocation: state.userLocation)
        } else {
          state.flowerSpotDetail = nil
        }
        return showSearchResult(result: result)
        
      case let .setSearchBarText(text):
        state.searchText = text
        return .none
        
      case .resetSearchBar:
        return .run { send in
          await MainActor.run {
            send(.showSearchResult(nil))
            send(.setSearchBarText(nil))
            send(.delegate(.resetSearchView))
          }
        }
        
      case let .showRegionList(isPresent):
        state.searchRegionList = .init()
        state.isShowRegionList = isPresent
        return .none
        
      case .changeRegionSheetDetent:
        if state.isShowRegionList {
          state.regionSheetDetent = .low
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

      case .presentToSearch:
        return .send(.delegate(.presentToSearch(state.searchText)))

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
          state.searchResult = flowerSpot
          return .send(.location(.moveLocation(flowerSpot.pinPoint)))
        }

      case .flowerSpotDetail:
        return .none
        
      case .binding, .delegate, .alertAcceptTapped, .location, .searchRegionList:
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
        await send(.setSearchBarText(result.streetName))
        await send(.location(.moveLocation(result.pinPoint)))
        await send(.fetchPathLines(result.id))
        await send(.flowerSpotDetail(.requestDetailInfo(result.id)))
      }
    }
  }
}

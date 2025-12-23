//
//  MapReducer.swift
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


extension MapReducer {
  public init() {
    
    @Dependency(\.flowerSpotClient) var flowerSpot
    @Dependency(\.openURL) var openURL
    
    let mapReducer = Reduce<State, Action> { state, action in
      switch action {
        
      case let .showToastView(message, buttonLabel):
        state.toastMessage = message
        state.toastLabel = buttonLabel
        return .none
      case .toastActionTapped:
        
        return .run { send in
          if let url = ExternalURL.report {
            await openURL(url)
          }
        }
      case .viewDidAppear:
        state.isViewAppeared = true
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
          await send(.location(.requestMapBounds(true)))
        }
        
        // 마커 탭 시, 디테일정보 불러오기 및 바텀시트 on
      case let .markerTapped(id):
        guard let id = id else {
          state.isNeedDeleteMarker = true
          return .none
        }
        return .run { send in
          await send(.fetchPathLines(id))
          await send(.detail(.requestDetailInfo(id)))
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
        return .send(.detail(.fetchDetailInfo(id)))
        
        // MARK: - Search
        
      case let .showSearchResult(result):
        state.searchResult = result
        state.detail.selectedItemDetail = nil
        state.detail.isDetailLoading = true
        return .run { send in
          if let result = result {
            await send(.setSearchBarText(result.streetName))
            await send(.location(.moveLocation(result.pinPoint)))
            await send(.fetchPathLines(result.id))
            await send(.detail(.requestDetailInfo(result.id)))
          }
        }
        
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
        
        // MARK: - Delegate
        
      case .presentToSearch:
        return .send(.delegate(.presentToSearch(state.searchText)))
        
      case .pushToSetting:
        return .send(.delegate(.pushToSetting))
        
      case let .detail(.presentToDetail(flowerSpot, bloomingStatus, distance, isVotedBlooming)):
        return .send(
          .delegate(
            .presentToDetail(
              flowerSpotData: flowerSpot,
              bloomingStatus: bloomingStatus,
              distance: distance,
              isVotedBlooming: isVotedBlooming
            )
          )
        )
        
      case let .detail(.fetchPathLines(id)):
        return .send(.fetchPathLines(id))
        
      case let .location(.showToastView(message, label)):
        return .send(.showToastView(message: message, buttonLabel: label))
        
      case let .location(.presentAlert(type)):
        return .send(.presentAlert(type: type))
        
      case .binding, .delegate, .location, .detail, .alertAcceptTapped:
        return .none
        
      }
    
    }
    self.init(
      reducer: mapReducer,
      location: Reduce(LocationReducer()),
      detail: Reduce(DetailReducer())
    )
    
  }
}

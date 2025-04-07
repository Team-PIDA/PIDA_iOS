//
//  MapReducer.swift
//
//  Map
//
//  Created by JiYeon
//

import MapFeatureInterface
import FlowerSpotDomainInterface
import BloomingDomainInterface
import ComposableArchitecture
import UserDefault
import Utility

extension MapReducer {
  public init() {
    @Dependency(\.fetchAllFlowerAddressUseCase) var fetchAllFlowerAddressUseCase
    
    let mapReducer = Reduce<State, Action> { state, action in
      switch action {
        
      case let .showToastView(message):
        state.toastMessage = message
        return .none
        
      case .viewDidAppear:
        state.isViewAppeared = true
        return .run { send in
          do {
            let _ = try await fetchAllFlowerAddressUseCase.execute()
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
        
      case let .location(.showToastView(message)):
        return .send(.showToastView(message: message))
        
      case .binding, .delegate, .location, .detail:
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

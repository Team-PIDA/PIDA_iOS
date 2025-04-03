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
import Utility

extension MapReducer {
  public init() {
    @Dependency(\.fetchAllFlowerPinUseCase) var fetchAllFlowerPinUseCase
    @Dependency(\.fetchAllFlowerAddressUseCase) var fetchAllFlowerAddressUseCase
    @Dependency(\.getFlowerSpotDetailUseCase) var getFlowerSpotDetailUseCase
    @Dependency(\.getBloomingStateUseCase) var getBloomingStateUseCase
    
    let mapReducer = Reduce<State, Action> {
      state,
      action in
      switch action {
        
      case let .showToastView(message):
        state.toastMessage = message
        return .none
        
        // MARK: - Map
        
      case .fetchUserLocation:
        return .run { _ in
          await LocationService.shared.requestUserLocation()
        }
      case .moveUserLocation:
        return .run { send in
          if let location = await LocationService.shared.userLocation {
            await send(.moveLocation(MapPoint(latitude: location.0, longitude: location.1)))
          }
        }
      case let .moveLocation(point):
        state.point = point
        return .none
      case let .fetchFlowers(positions):
        return .run { send in
          do {
            let result = try await fetchAllFlowerPinUseCase.execute(
              region: "SEOUL",
              swLat: positions[0].latitude,
              swLng: positions[0].longitude,
              neLat: positions[1].latitude,
              neLng: positions[1].longitude
            )
            if result.count == 0 {
              await send(.showToastView(message: "이 근방에는 꽃길이 없어요."))
            }
            await send(.storeFlowerData(result))
          } catch let error as NetworkError {
            await send(.mapSearchError(error.localizedDescription))
          } catch let error as FoundationError {
            await send(.mapSearchError(error.localizedDescription))
          } catch {
            await send(.mapSearchError(error.localizedDescription))
          }
        }
      case let .storeFlowerData(data):
        state.flowerSpots.removeAll()
        data.forEach {
          state.flowerSpots[$0.id] = $0
        }
        return .none
        
        // 마커 탭 시, 디테일정보 불러오기 및 바텀시트 on
      case let .markerTapped(id):
        guard let id = id else {
          state.isNeedDeleteMarker = true
          return .none
        }
        
        return .run { send in
          await send(.fetchPathLines(id))
          await send(.requestDetailInfo(id))
        }
        
      case let .requestDetailInfo(id):
        state.selectedItemDetail = nil
        state.isDetailLoading = true
        return .run { send in
          do {
            async let detailResult = try await getFlowerSpotDetailUseCase.execute(id: id)
            async let bloomingResult = try await getBloomingStateUseCase.execute(id: id)
            let (detail, blooming) = try await (detailResult, bloomingResult)
            await MainActor.run {
              send(.detailResponse(detail))
              send(.bloomingResponse(blooming))
            }
          } catch let error as NetworkError {
            print(error.errorDescription)
          } catch let error as FoundationError {
            print(error.errorDescription)
          } catch {
            print(error.localizedDescription)
          }
        }
        
      case let .detailResponse(item):
        state.selectedItemDetail = item
        if state.selectedItemBlooming != nil {
          state.isDetailLoading = false
        }
        return .none
      case let .bloomingResponse(item):
        state.selectedItemBlooming = item
        if state.selectedItemDetail != nil {
          state.isDetailLoading = false
        }
        return .none
      case let .fetchPathLines(id):
        if let data = state.flowerSpots[id] {
          state.selectedPathLines = data.path
          state.isNeedDrawMarker = true
        } else {
          state.selectedPathLines = []
        }
        return .none
        
      case let .mapSearchError(error):
        print("=============")
        print(error ?? "ERROR!")
        print("=============")
        return .none
        
      case let .requestMapBounds(isRequest):
        state.requestMapBound = isRequest
        state.researchButtonEnable = false
        return .none
        
      case let .selectedItem(item):
        state.selectedItem = item
        return .send(.fetchPathLines(item.id))
        
      case .dismissBottomSheet:
        print("바텀시트 닫기")
        state.selectedItemDetail = nil
        return .none
        
      case .viewDidAppear:
        state.isViewAppeared = true
        return .run { send in
          do {
            let _ = try await fetchAllFlowerAddressUseCase.execute()
          } catch let error as NetworkError {
            await send(.mapSearchError(error.localizedDescription))
          } catch let error as FoundationError {
            await send(.mapSearchError(error.localizedDescription))
          } catch {
            await send(.mapSearchError(error.localizedDescription))
          }
          await send(.requestMapBounds(true))
        }
        
        // MARK: - Search
        
        // 검색 결과
      case let .showSearchResult(result):
        state.searchResult = result
        state.selectedItemDetail = nil
        state.isDetailLoading = true
        return .run { send in
          if let result = result {
            await send(.setSearchBarText(result.streetName))
            await send(.moveLocation(result.pinPoint))
            await send(.fetchPathLines(result.id))
            await send(.requestDetailInfo(result.id))
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
      case let .presentToDetail(flowerSpot, bloomingStatus):
        return .send(
          .delegate(
            .presentToDetail(
              flowerSpotData: flowerSpot,
              bloomingStatus: bloomingStatus
            )
          )
        )
        // MARK: - None
        
      case .binding,
          .delegate:
        return .none
      }
    }
    self.init(reducer: mapReducer)
    
  }
}

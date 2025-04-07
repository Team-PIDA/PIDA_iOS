//
//  DetailReducer.swift
//  MapFeature
//
//  Created by Jiyeon on 4/7/25.
//  Copyright © 2025 com.pida.me.ios. All rights reserved.
//

import MapFeatureInterface
import FlowerSpotDomainInterface
import BloomingDomainInterface
import ComposableArchitecture
import Utility
import UserDefault

extension MapReducer {
  
  struct DetailReducer: Reducer {
    
    @Dependency(\.getFlowerSpotDetailUseCase) var getFlowerSpotDetailUseCase
    @Dependency(\.getBloomingStateUseCase) var getBloomingStateUseCase
    @Dependency(\.verifyBloomingTodayUseCase) var verifyBloomingTodayUseCase
    
    func reduce(into state: inout State, action: DetailAction) -> Effect<DetailAction> {
      switch action {
      
      case let .selectedItem(item):
        state.selectedItem = item
        return .send(.fetchPathLines(item.id))
        
      case let .requestDetailInfo(id):
        state.selectedItemDetail = nil
        state.selectedItemBlooming = nil
        state.selectedItemVote = nil
        state.isDetailLoading = true
        state.isBottomSheetPresented = true
        return .run { send in
          do {
            async let detailResult = try getFlowerSpotDetailUseCase.execute(id: id)
            async let bloomingResult = try getBloomingStateUseCase.execute(id: id)
            let verifyTodayResult = UserDefault.isLoggedIn == true
            ? try await verifyBloomingTodayUseCase.execute(id: id)
            : VerifyBloomingStateEntity(isBlooming: false)
            let (detail, blooming) = try await (detailResult, bloomingResult)
            await MainActor.run {
              send(.detailResponse(detail))
              send(.bloomingResponse(blooming))
              send(.verifyTodayBlooming(verifyTodayResult))
            }
          } catch let error as NetworkError {
            print(error.errorDescription)
          } catch let error as FoundationError {
            print(error.errorDescription)
          } catch {
            print(error.localizedDescription)
          }
        }
        
      case let .fetchDetailInfo(id):
        state.selectedItemDetail = nil
        state.selectedItemBlooming = nil
        state.selectedItemVote = nil
        state.isNeedFetchDetail = true
        return .run { send in
          do {
            async let detailResult = try await getFlowerSpotDetailUseCase.execute(id: id)
            async let bloomingResult = try await getBloomingStateUseCase.execute(id: id)
            async let verifyTodayResult = try await verifyBloomingTodayUseCase.execute(id: id)
            let (detail, blooming, verifyToday) = try await (detailResult, bloomingResult, verifyTodayResult)
            await MainActor.run {
              send(.detailResponse(detail))
              send(.bloomingResponse(blooming))
              send(.verifyTodayBlooming(verifyToday))
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
        return .send(.calculateDistance(item.pinPoint))
        
      case let .bloomingResponse(item):
        state.selectedItemBlooming = item
        if state.selectedItemDetail != nil && state.selectedItemVote != nil {
          state.isDetailLoading = false
          return .send(.allDataUpdated)
        }
        return .none
        
      case let .verifyTodayBlooming(item):
        state.selectedItemVote = item
        if state.selectedItemDetail != nil && state.selectedItemBlooming != nil {
          state.isDetailLoading = false
          return .send(.allDataUpdated)
        }
        return .none
        
      case .allDataUpdated:
        if state.isNeedFetchDetail {
          state.isNeedFetchDetail = false
          if let item = state.selectedItemDetail,
             let bloomingStatus = state.selectedItemBlooming,
             let isVotedBlooming = state.selectedItemVote {
            return .run { [distance = state.distance] send in
              await send(.updateMarkerStatus(item.bloomingStatus, id: item.id))
              await send(
                .presentToDetail(
                  flowerSpotData: item,
                  bloomingStatus: bloomingStatus,
                  distance: distance,
                  isVotedBlooming: isVotedBlooming
                )
              )
            }
          }
        }
        return .none
        
      case let .calculateDistance(pinPoint):
        guard let userPoint = state.userLocation else {
          state.distance = .zero
          return .none
        }
        state.distance = pinPoint.distance(from: userPoint)
        if state.selectedItemBlooming != nil && state.selectedItemVote != nil {
          state.isDetailLoading = false
          return .send(.allDataUpdated)
        }
        return .none
        
      case let .updateMarkerStatus(status, id):
        if state.flowerSpots[id] != .none {
          state.flowerSpots[id]?.bloomingStatus = status
        } else if state.searchResult != .none {
          state.searchResult?.bloomingStatus = status
        }
        state.updateMarkerStatus = status
        return .none
        
      case .dismissBottomSheet:
        state.isBottomSheetPresented = false
        state.selectedItemDetail = nil
        state.selectedItemBlooming = nil
        state.distance = .zero
        return .none
        
        // 부모 리듀서에 전달 할 액션
      case .presentToDetail, .fetchPathLines: return .none
      }
    }
  }
}

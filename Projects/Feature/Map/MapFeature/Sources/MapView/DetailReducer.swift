//
//  DetailReducer.swift
//  MapFeature
//
//  Created by Jiyeon on 4/7/25.
//  Copyright © 2025 com.pida.me.ios. All rights reserved.

//
import Shared
import NMapsMap
import DesignKit
import ComposableArchitecture
import MapFeatureInterface
import FlowerSpotClient
import BloomingClient
import CacheClient

extension MapReducer {
  
  
  struct DetailReducer: Reducer {
    
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    @Dependency(\.bloomingClient) var bloomingClient
    @Dependency(\.cache) var cache
    
    func reduce(into state: inout State, action: DetailAction) -> Effect<DetailAction> {
      switch action {
      
      case let .selectedItem(item):
        state.detail.selectedItem = item
        return .send(.fetchPathLines(item.id))
        
      case let .requestDetailInfo(id):
        state.detail.selectedItemDetail = nil
        state.detail.selectedItemBlooming = nil
        state.detail.selectedItemVote = nil
        state.detail.isDetailLoading = true
        state.detail.isBottomSheetPresented = true
        return .run { send in
          do {
            async let detailResult = try flowerSpotClient.getFlowerSpotDetail(id: id)
            async let bloomingResult = try bloomingClient.getBloomingState(id: id)
            let verifyTodayResult = UserDefaultsKeys.isLoggedIn == true
            ? try await bloomingClient.verifyBloomingToday(id: id)
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
        state.detail.selectedItemDetail = nil
        state.detail.selectedItemBlooming = nil
        state.detail.selectedItemVote = nil
        state.detail.isNeedFetchDetail = true
        return .run { send in
          do {
            async let detailResult = try flowerSpotClient.getFlowerSpotDetail(id: id)
            async let bloomingResult = try bloomingClient.getBloomingState(id: id)
            async let verifyTodayResult = try await bloomingClient.verifyBloomingToday(id: id)
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
        state.detail.selectedItemDetail = item
        return .send(.calculateDistance(item.pinPoint))
        
      case let .bloomingResponse(item):
        state.detail.selectedItemBlooming = item
        if state.detail.selectedItemDetail != nil && state.detail.selectedItemVote != nil {
          state.detail.isDetailLoading = false
          return .send(.allDataUpdated)
        }
        return .none
        
      case let .verifyTodayBlooming(item):
        state.detail.selectedItemVote = item
        if state.detail.selectedItemDetail != nil && state.detail.selectedItemBlooming != nil {
          state.detail.isDetailLoading = false
          return .send(.allDataUpdated)
        }
        return .none
        
      case .allDataUpdated:
        if state.detail.isNeedFetchDetail {
          state.detail.isNeedFetchDetail = false
          if let item = state.detail.selectedItemDetail,
             let bloomingStatus = state.detail.selectedItemBlooming,
             let isVotedBlooming = state.detail.selectedItemVote,
             let bloomStatus = BloomStatus(rawValue: item.bloomingStatus){
            return .run { [distance = state.detail.distance] send in
              await send(.updateMarkerStatus(bloomStatus, id: item.id))
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
          state.detail.distance = .zero
          return .none
        }
        state.detail.distance = pinPoint.distance(from: userPoint)
        if state.detail.selectedItemBlooming != nil && state.detail.selectedItemVote != nil {
          state.detail.isDetailLoading = false
          return .send(.allDataUpdated)
        }
        return .none
        
      case let .updateMarkerStatus(status, id):
        if state.flowerSpots[id] != .none {
          state.flowerSpots[id]?.bloomingStatus = status.rawValue
        } else if state.searchResult != .none {
          state.searchResult?.bloomingStatus = status.rawValue
        }
        state.detail.updateMarkerStatus = status
        return .none
        
      case .dismissBottomSheet:
        state.detail.isBottomSheetPresented = false
        state.detail.selectedItemDetail = nil
        state.detail.selectedItemBlooming = nil
        state.detail.distance = .zero
        return .none
        
        // 부모 리듀서에 전달 할 액션
      case .presentToDetail, .fetchPathLines: return .none
      }
    }
  }
}

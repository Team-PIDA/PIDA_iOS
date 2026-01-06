//
//  DetailFeature.swift
//  MapFeature
//
//  Created by Jiyeon on 4/7/25.
//  Copyright © 2025 com.pida.me.ios. All rights reserved.

import Shared
import NMapsMap
import DesignKit
import ComposableArchitecture
import MapFeatureInterface
import FlowerSpotClient
import BloomingClient
import CacheClient
import LocationClient

extension DetailFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }
  
  struct Core: Reducer {
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    @Dependency(\.bloomingClient) var bloomingClient
    @Dependency(\.cache) var cache
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
        return requestDetailInfo(id: id)
        
      case let .fetchDetailInfo(id):
        state.selectedItemDetail = nil
        state.selectedItemBlooming = nil
        state.selectedItemVote = nil
        state.isNeedFetchDetail = true
        return fetchDetailInfo(id: id)
        
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
             let isVotedBlooming = state.selectedItemVote,
             let bloomStatus = BloomStatus(rawValue: item.bloomingStatus){
            return .run { [distance = state.distance] send in
              await send(.delegate(.updateMarkerStatus(bloomStatus, id: item.id)))
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
        
      case .dismissBottomSheet:
        state.isBottomSheetPresented = false
        state.selectedItemDetail = nil
        state.selectedItemBlooming = nil
        state.distance = .zero
        return .none
        
        // 부모 리듀서에 전달 할 액션
      case .binding, .presentToDetail, .fetchPathLines, .delegate:
        return .none
      }
    }
  }
}

extension DetailFeature.Core {
  private func requestDetailInfo(id: Int) -> Effect<Action> {
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
  }
  
  private func fetchDetailInfo(id: Int) -> Effect<Action> {
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
  }
}

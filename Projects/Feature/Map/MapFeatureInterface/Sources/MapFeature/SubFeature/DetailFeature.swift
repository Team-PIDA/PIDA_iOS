//
//  DetailFeature.swift
//  MapFeature
//
//  Created by Jiyeon on 4/7/25.
//  Copyright © 2025 com.pida.me.ios. All rights reserved.
//

import DesignKit
import ComposableArchitecture
import FlowerSpotClient
import BloomingClient
import Shared

@Reducer
public struct DetailFeature {
  private let reducer: Reduce<State, Action>
  
  public init(
    reducer: Reduce<State, Action>,
  ) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var userLocation: Coordinate? = nil
    
    public var selectedItem: FlowerSpotEntity? = nil
    /// 네트워크로 받아온 상세 데이터
    public var selectedItemDetail: FlowerSpotEntity? = nil
    /// 네트워크로 받아온 개화 상태 데이터
    public var selectedItemBlooming: BloomStatusEntity? = nil
    /// 네트워크로 받아온 투표 상태 데이터
    public var selectedItemVote: VerifyBloomingStateEntity? = nil
    /// 로딩 여부
    public var isDetailLoading: Bool = false
    /// DetailView가 fetch가 필요한 지 여부 flag
    public var isNeedFetchDetail: Bool = false
    /// 현재 위치에서 특정 지점까지의 거리 (단위: 킬로미터)
    public var distance: Double = .zero
    /// 바텀시트 띄우기 트리거
    public var isBottomSheetPresented: Bool = false
    
    public var updateMarkerStatus: BloomStatus? = nil
    
    public init() {}
  }
  
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case fetchPathLines(Int)
    case selectedItem(FlowerSpotEntity)
    
    case requestDetailInfo(Int)
    case fetchDetailInfo(Int)
    
    case detailResponse(FlowerSpotEntity)
    case bloomingResponse(BloomStatusEntity)
    case verifyTodayBlooming(VerifyBloomingStateEntity)
    case allDataUpdated
    
    case calculateDistance(Coordinate)
    
    case dismissBottomSheet
    case presentToDetail(
      flowerSpotData: FlowerSpotEntity,
      bloomingStatus: BloomStatusEntity,
      distance: Double,
      isVotedBlooming: VerifyBloomingStateEntity
    )
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case updateMarkerStatus(BloomStatus, id: Int)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
    
  }
}

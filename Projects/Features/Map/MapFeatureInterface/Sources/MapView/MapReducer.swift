//
//  MapReducer.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import FlowerSpotDomainInterface
import BloomingDomainInterface
import SearchDomainInterface
import ComposableArchitecture

@Reducer
public struct MapReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    
    /// 특정 지점으로 이동하기 위한 위치정보
    public var point: MapPoint? = nil
    /// 유저의 현재 위치
    public var userLocation: MapPoint? = nil
    /// 현재 지도에 보여 줄 FlowerSpot 데이터
    public var flowerSpots: [Int: FlowerSpot] = [:]
    /// 현재 그려져있는 경로
    public var selectedPathLines: [MapPoint] = []
    /// 지도에 마커 및 경로 비활성화 트리거
    public var isNeedDeleteMarker: Bool = false
    /// 지도에 마커 및 경로 그리기 트리거
    public var isNeedDrawMarker: Bool = false
    /// 지도 범위 요청 트리거
    public var requestMapBound: Bool = false
    /// 현위치 재검색 버튼 활성화 여부
    public var researchButtonEnable: Bool = false
    /// 현재 위치에서 특정 지점까지의 거리 (단위: 킬로미터)
    public var distance: Double = .zero
    /// DetailView가 fetch가 필요한 지 여부 flag
    public var isNeedFetchDetail: Bool = false
    
    /// 검색 결과 데이터
    public var searchResult: FlowerSpot? = nil
    /// 검색 결과 텍스트
    public var searchText: String? = nil
    
    public var toastMessage: String? = nil
    
    public var selectedItem: FlowerSpot? = nil
    /// 네트워크로 받아온 상세 데이터
    public var selectedItemDetail: FlowerSpot? = nil
    /// 네트워크로 받아온 개화 상태 데이터
    public var selectedItemBlooming: BloomStatusEntity? = nil
    /// 네트워크로 받아온 투표 상태 데이터
    public var selectedItemVote: VerifyBloomingStateEntity? = nil
    /// 로딩 여부
    public var isDetailLoading: Bool = false
    
    public var isViewAppeared: Bool = false
    /// 바텀시트 띄우기 트리거
    public var isBottomSheetPresented: Bool = false
    

    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case showToastView(message: String?)
    
    // MARK: - Map
    
    case fetchUserLocation
    case moveUserLocation
    case saveUserLocation(MapPoint)
    case moveLocation(MapPoint)
    case fetchFlowers([MapPoint])
    case storeFlowerData([FlowerSpot])
    case markerTapped(id: Int?)
    case detailResponse(FlowerSpot)
    case bloomingResponse(BloomStatusEntity)
    case verifyTodayBlooming(VerifyBloomingStateEntity)
    case allDataUpdated
    case fetchPathLines(Int)
    case requestMapBounds(Bool)
    case mapSearchError(String?)
    case selectedItem(FlowerSpot)
    case dismissBottomSheet
    case requestDetailInfo(Int)
    case fetchDetailInfo(Int)
    
    
    case calculateDistance(MapPoint)
    
    // MARK: - Life Cycle
    case viewDidAppear
    
    // MARK: - Search
    
    case showSearchResult(FlowerSpot?) // TODO: - ItemType
    case setSearchBarText(String?)
    case resetSearchBar
    
    // MARK: - Delegate
    
    case delegate(Delegate)
    case presentToSearch
    case pushToSetting
    case presentToDetail(
      flowerSpotData: FlowerSpot,
      bloomingStatus: BloomStatusEntity,
      distance: Double,
      isVotedBlooming: VerifyBloomingStateEntity
    )
  }
  
  public enum Delegate: Equatable {
    case presentToSearch(String?)
    case pushToSetting
    case resetSearchView
    case presentToDetail(
      flowerSpotData: FlowerSpot,
      bloomingStatus: BloomStatusEntity,
      distance: Double,
      isVotedBlooming: VerifyBloomingStateEntity
    )
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

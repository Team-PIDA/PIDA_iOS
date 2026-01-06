//
//  MapFeature.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import DesignKit
import ComposableArchitecture
import FlowerSpotClient
import BloomingClient
import FlowerSpotDetailFeatureInterface
import Shared

@Reducer
public struct MapFeature {
  private let reducer: Reduce<State, Action>
  private let location: Reduce<LocationFeature.State, LocationFeature.Action>
  private let detail: Reduce<DetailFeature.State, DetailFeature.Action>
  // MARK: - 신규 Reducer (FlowerSpotDetailFeature 통합용)
  private let flowerSpotDetail: FlowerSpotDetailFeature

  public init(
    reducer: Reduce<State, Action>,
    location: Reduce<LocationFeature.State, LocationFeature.Action>,
    detail: Reduce<DetailFeature.State, DetailFeature.Action>,
    flowerSpotDetail: FlowerSpotDetailFeature
  ) {
    self.reducer = reducer
    self.location = location
    self.detail = detail
    self.flowerSpotDetail = flowerSpotDetail
  }
  
  @ObservableState
  public struct State: Equatable {
    
    /// 유저의 현재 위치
    public var userLocation: Coordinate? = nil
    
    /// 현재 지도에 보여 줄 FlowerSpot 데이터
    public var flowerSpots: [Int: FlowerSpotEntity] = [:]
    /// 현재 그려져있는 경로
    public var selectedPathLines: [Coordinate] = []
    /// 지도에 마커 및 경로 비활성화 트리거
    public var isNeedDeleteMarker: Bool = false
    /// 지도에 마커 및 경로 그리기 트리거
    public var isNeedDrawMarker: Bool = false
    /// 지도 범위 요청 트리거
    public var requestMapBound: Bool = false
    /// 현위치 재검색 버튼 활성화 여부
    public var researchButtonEnable: Bool = false
    /// 검색 결과 데이터
    public var searchResult: FlowerSpotEntity? = nil
    /// 검색 결과 텍스트
    public var searchText: String? = nil
    
    public var toastMessage: String? = nil
    
    public var toastLabel: String? = nil
    
    public var isViewAppeared: Bool = false
    
    public var alertType: AlertType? = nil
    
    public var detail: DetailFeature.State = .init()

    public var location: LocationFeature.State = .init()

    // MARK: - 신규 State (FlowerSpotDetailFeature 통합용)
    /// Optional State 패턴: nil이면 바텀시트 숨김, 값이 있으면 바텀시트 표시
    public var flowerSpotDetail: FlowerSpotDetailFeature.State? = nil

    public init() {}
  }
  
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationFeature.Action)
    case detail(DetailFeature.Action)
    // MARK: - 신규 Action (FlowerSpotDetailFeature 통합용)
    case flowerSpotDetail(FlowerSpotDetailFeature.Action)
    
    case showToastView(message: String?, buttonLabel: String?)
    case moveToReportURL
    case viewDidAppear
    
    case requestMapBounds(Bool)
    case fetchAllFlowerAddress
    case markerTapped(id: Int?)
    case fetchPathLines(Int)
    case fetchDetailInfo(Int)
    
    case showSearchResult(FlowerSpotEntity?)
    case setSearchBarText(String?)
    case resetSearchBar
    
    case presentAlert(type: AlertType)
    case alertCancelTapped
    case alertAcceptTapped(AlertType)
    case clearAlertState
    
    case delegate(Delegate)
    case presentToSearch
    case pushToSetting
  }
  
  // MARK: - Delegate

  public enum Delegate: Equatable {
    case presentToSearch(String?)
    case pushToSetting
    case resetSearchView
    case presentToDetail(
      flowerSpotData: FlowerSpotEntity,
      bloomingStatus: BloomStatusEntity,
      distance: Double,
      isVotedBlooming: VerifyBloomingStateEntity
    )
    // MARK: - 신규 Delegate (FlowerSpotDetailFeature 통합용)
    case presentToBlooming(id: Int, streetName: String)
    case presentToLogin(id: Int)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.location, action: \.location) {
      location
    }
    Scope(state: \.detail, action: \.detail) {
      detail
    }
    // MARK: - 신규 Reducer 연결 (Optional State 패턴)
    .ifLet(\.flowerSpotDetail, action: \.flowerSpotDetail) {
      flowerSpotDetail
    }
    reducer
  }
}

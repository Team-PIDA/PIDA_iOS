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
import FlowerSpotDetailFeatureInterface
import SearchRegionListFeatureInterface
import Shared

@Reducer
public struct MapFeature {
  private let reducer: Reduce<State, Action>
  private let location: Reduce<LocationFeature.State, LocationFeature.Action>
  private let flowerSpotDetail: FlowerSpotDetailFeature
  private let searchRegionList: SearchRegionListFeature

  public init(
    reducer: Reduce<State, Action>,
    location: Reduce<LocationFeature.State, LocationFeature.Action>,
    flowerSpotDetail: FlowerSpotDetailFeature,
    searchRegionList: SearchRegionListFeature
  ) {
    self.reducer = reducer
    self.location = location
    self.flowerSpotDetail = flowerSpotDetail
    self.searchRegionList = searchRegionList
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
    
    /// 상세 화면 진입 시 루트 화면
    public var detailRoot: DetailRoot? = nil
    /// 리전 검색 결과 저장
    public var regionResult: FlowerSpotEntity? = nil // TODO: - 추후 타입 변경 필요
    
    public var toastMessage: String? = nil
    
    public var toastLabel: String? = nil
    
    public var isViewAppeared: Bool = false
    
    public var isShowRegionList: Bool = false
    
    public var regionSheetDetent: BottomSheetDetent = .medium
    
    public var alertType: AlertType? = nil

    public var location: LocationFeature.State = .init()

    /// Optional State 패턴: nil이면 바텀시트 숨김, 값이 있으면 바텀시트 표시
    public var flowerSpotDetail: FlowerSpotDetailFeature.State? = nil
    public var searchRegionList: SearchRegionListFeature.State? = nil

    public init() {}
  }
  
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationFeature.Action)
    case flowerSpotDetail(FlowerSpotDetailFeature.Action)
    case searchRegionList(SearchRegionListFeature.Action)
    
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
    case showRegionList(FlowerSpotEntity?, Bool) // TODO: - 리전 검색 결과에 따른 data 넘기기
    case changeRegionSheetDetent
    case searchBackButtonTapped
    case handleSearchBackNavigation
    
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
    case presentToBlooming(id: Int, streetName: String)
    case presentToLogin(id: Int)
    case mapDidLoad
  }
  
  public enum DetailRoot: Equatable {
    case region
    case search
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.location, action: \.location) {
      location
    }
    .ifLet(\.flowerSpotDetail, action: \.flowerSpotDetail) {
      flowerSpotDetail
    }
    .ifLet(\.searchRegionList, action: \.searchRegionList) {
      searchRegionList
    }
    reducer
  }
}

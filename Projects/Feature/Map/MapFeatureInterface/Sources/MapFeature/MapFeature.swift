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
import SearchClient
import CategoryFeatureInterface
import FlowerSpotDetailFeatureInterface
import SearchRegionListFeatureInterface
import Shared

@Reducer
public struct MapFeature {
  private let reducer: Reduce<State, Action>
  private let location: Reduce<LocationFeature.State, LocationFeature.Action>
  private let mapSearch: Reduce<MapSearchFeature.State, MapSearchFeature.Action>
  private let category: Reduce<CategoryFeature.State, CategoryFeature.Action>
  private let flowerSpotDetail: FlowerSpotDetailFeature
  private let searchRegionList: SearchRegionListFeature

  public init(
    reducer: Reduce<State, Action>,
    location: Reduce<LocationFeature.State, LocationFeature.Action>,
    mapSearch: Reduce<MapSearchFeature.State, MapSearchFeature.Action>,
    category: Reduce<CategoryFeature.State, CategoryFeature.Action>,
    flowerSpotDetail: FlowerSpotDetailFeature,
    searchRegionList: SearchRegionListFeature
  ) {
    self.reducer = reducer
    self.location = location
    self.mapSearch = mapSearch
    self.category = category
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
    /// 초기 지도 범위 요청 트리거 (초기 진입용)
    public var shouldRequestInitialBounds: Bool = false
    /// 현위치 재검색 버튼 활성화 여부
    public var researchButtonEnable: Bool = false
    
    /// 지도 액션 명령 큐
    public var mapActions: [MapAction] = []
    
    public var toastMessage: String? = nil
    
    public var toastLabel: String? = nil
    
    public var isViewAppeared: Bool = false
    
    /// 초기 지도 로드 완료 여부
    public var isInitialMapLoadCompleted: Bool = false
    
    public var alertType: AlertType? = nil

    public var location: LocationFeature.State = .init()

    public var mapSearch: MapSearchFeature.State = .init()

    public var category: CategoryFeature.State = .init()

    /// Optional State 패턴: nil이면 바텀시트 숨김, 값이 있으면 바텀시트 표시
    public var flowerSpotDetail: FlowerSpotDetailFeature.State? = nil
    public var searchRegionList: SearchRegionListFeature.State? = nil

    public init() {}
  }
  
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationFeature.Action)
    case mapSearch(MapSearchFeature.Action)
    case category(CategoryFeature.Action)
    case flowerSpotDetail(FlowerSpotDetailFeature.Action)
    case searchRegionList(SearchRegionListFeature.Action)
    
    case showToastView(message: String?, buttonLabel: String?)
    case moveToReportURL
    case viewDidAppear
    
    case requestMapBounds(Bool)
    case addMapAction(MapAction)
    case markerTapped(id: Int?)
    case fetchPathLines(Int)
    case fetchDetailInfo(Int)
    
    case presentAlert(type: AlertType)
    case alertCancelTapped
    case alertAcceptTapped(AlertType)
    case clearAlertState
    
    case delegate(Delegate)
    case pushToSetting
  }
  
  // MARK: - Delegate

  public enum Delegate: Equatable {
    case presentToSearch(String?)
    case pushToSetting
    case presentToBlooming(id: Int, streetName: String, distance: Double?)
    case presentToLogin(id: Int)
    case mapDidLoad
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.location, action: \.location) {
      location
    }
    Scope(state: \.mapSearch, action: \.mapSearch) {
      mapSearch
    }
    Scope(state: \.category, action: \.category) {
      category
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

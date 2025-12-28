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
import Shared

@Reducer
public struct MapFeature {
  private let reducer: Reduce<State, Action>
  private let location: Reduce<State, LocationAction>
  private let detail: Reduce<State, DetailAction>
  
  public init(
    reducer: Reduce<State, Action>,
    location: Reduce<State, LocationAction>,
    detail: Reduce<State, DetailAction>
  ) {
    self.reducer = reducer
    self.location = location
    self.detail = detail
  }
  
  @ObservableState
  public struct State: Equatable {
    /// 특정 지점으로 이동하기 위한 위치정보
    public var point: Coordinate? = nil
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
    
    public var detail: DetailState = .init()
    
    public var location: LocationState = .init()
    
    public init() {}
  }
  
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationAction)
    case detail(DetailAction)
    
    case showToastView(message: String?, buttonLabel: String?)
    case toastActionTapped
    case viewDidAppear
    
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
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.self, action: \.location) {
      location
    }
    Scope(state: \.self, action: \.detail) {
      detail
    }
    reducer
    
  }
}

//
//  MapReducer.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import FlowerSpotDomainInterface
import ComposableArchitecture

@Reducer
public struct MapReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    /// 특정 좌표로 이동하기 위한 프로퍼티
    public var point: MapPoint? = nil
    /// 현재 지도에 보여 줄 FlowerSpot 데이터
    public var flowerSpots: [Int: FlowerSpot] = [:]
    /// 현재 그려져있는 경로
    public var selectedPathLines: [MapPoint] = []
    /// 검색 결과 데이터
    public var searchResult: FlowerSpot? = nil
    /// 검색 결과 텍스트
    public var searchText: String? = nil
    /// 지도 범위 요청 트리거
    public var requestMapBound: Bool = false
    /// 현위치 재검색 버튼 활성화 여부
    public var researchButtonEnable: Bool = false
    
    public var toastMessage: String? = nil
    
    public var selectedItem: FlowerSpot? = nil
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case showToastView(message: String?)
    
    // MARK: - Map
    
    case fetchUserLocation
    case moveUserLocation
    case moveLocation(MapPoint)
    case fetchFlowers([MapPoint])
    case storeFlowerData([FlowerSpot])
    case markerTapped(id: Int?)
    case fetchPathLines(Int)
    case requestMapBounds(Bool)
    case mapSearchError(String?)
    case selectedItem(FlowerSpot)
    
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
    case presentToDetail(id: Int)
  }
  
  public enum Delegate: Equatable {
    case presentToSearch
    case pushToSetting
    case resetSearchView
    case presentToDetail(id: Int)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

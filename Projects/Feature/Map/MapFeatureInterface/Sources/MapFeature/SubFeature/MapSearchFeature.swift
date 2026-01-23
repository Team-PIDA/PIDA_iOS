//
//  MapSearchFeature.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 1/21/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Shared
import DesignKit
import FlowerSpotClient
import SearchClient

@Reducer
public struct MapSearchFeature {
  private let reducer: Reduce<State, Action>
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    /// 검색 결과 데이터
    public var searchResult: FlowerSpotEntity? = nil
    /// 검색 결과 텍스트
    public var searchText: String? = nil
    /// 상세 화면 진입 시 루트 화면
    public var detailRoot: DetailRoot? = nil
    /// 리전 검색 결과 저장
    public var regionResult: RegionInfoEntity? = nil
    /// 리전 검색 리스트 화면 show 여부
    public var isShowRegionList: Bool = false
    /// 리전 검색 리스트 바텀시트 detent
    public var regionSheetDetent: BottomSheetDetent = .medium
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    /// 검색 키워드 저장
    case setSearchBarText(String?)
    /// search bar 키워드 초기화
    case resetSearchBar
    /// 꽃길 검색 결과
    case showSearchResult(FlowerSpotEntity?)
    /// 검색 화면 전환
    case presentToSearch
    
    /// 리전 검색 결과
    case showRegionList(data: RegionInfoEntity?)
    /// 리전 검색 화면 숨기기 (리전 검색 화면에서 화면 전환 시)
    case hideRegionList
    /// 리전 검색 시트 detent 변경
    case changeRegionSheetDetent
    
    /// SearchBar 뒤로가기 버튼 탭
    case searchBackButtonTapped
    /// SearchBar 뒤로가기 시 화면 전환 처리
    case handleSearchBackNavigation
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case showSearchResult(FlowerSpotEntity?)
    case presentToSearch(String?)
    case showSearchRegionList(RegionInfoEntity?)
    case resetMarkerTapped
    case dismissFlowerSpotDetil
  }
  
  public enum DetailRoot: Equatable {
    case region
    case search
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

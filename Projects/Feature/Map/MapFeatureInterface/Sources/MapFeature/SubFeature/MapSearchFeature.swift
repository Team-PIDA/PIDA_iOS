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
    /// 현재 네비게이션 상태
    public var currentNavigation: NavigationState = .map
    /// 리전 검색 결과 저장
    public var regionResult: RegionInfoEntity? = nil
    /// 리전 검색 리스트 화면 show 여부
    public var isShowRegionList: Bool = false
    /// 리전 검색 리스트 바텀시트 detent
    public var regionSheetDetent: BottomSheetDetent = .medium
    /// 리전 검색 리스트 바텀시트 높이
    public var regionBottomSheetHeight: CGFloat = 0
    
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
    /// 리전 검색 시트 detent 변경
    case changeRegionSheetDetent
    
    /// SearchBar 뒤로가기 버튼 탭
    case searchBackButtonTapped
    /// SearchBar 뒤로가기 시 화면 전환 처리
    case handleSearchBackNavigation
    /// 리전리스트에서 상세로 이동 시 네비게이션 상태 설정
    case setNavigationFromRegionList
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case showSearchResult(FlowerSpotEntity?)
    case presentToSearch(String?)
    case showSearchRegionList(RegionInfoEntity?)
    case resetMarkerTapped
    case dismissFlowerSpotDetail
  }
  
  public enum NavigationState: Equatable {
    case map                                    // 기본 지도 화면
    case regionList          // 리전 검색 결과 리스트
    case flowerDetail(DetailSource)    // 꽃 상세 화면
    
    public enum DetailSource: Equatable {
      case fromSearch         // 검색에서 온 상세
      case fromRegionList     // 리전리스트에서 온 상세
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

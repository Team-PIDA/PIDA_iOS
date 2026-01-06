//
//  FlowerSpotDetailFeature.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import ComposableArchitecture
import FlowerSpotClient
import BloomingClient
import DesignKit

@Reducer
public struct FlowerSpotDetailFeature {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  @ObservableState
  public struct State: Equatable {
    // MARK: - 기존 필드 (유지)
    public var flowerSpotData: FlowerSpotEntity = .init(
      id: 0,
      recentlyVisitedCount: 0,
      bloomingStatus: "NOT_BLOOMED",
      streetName: "",
      path: [],
      pinPoint: .init(latitude: 0, longitude: 0),
      region: ""
    )
    public var bloomingStatus: BloomStatusEntity = .init(totalCount: 0, dayStatuses: [])
    public var distance: Double = .zero
    public var spotId: Int = 0
    public var toastMessage: String? = nil
    public var isNeedDrawPath: Bool = false
    public var isNeedDeletePath: Bool = false
    public var isShowLoginAlert: Bool = false
    public var isVotedBlooming: VerifyBloomingStateEntity = .init(isBlooming: false)

    // MARK: - 신규 필드 (DetailFeature에서 흡수)
    /// 데이터 로딩 중 여부
    public var isDetailLoading: Bool = false
    /// 마커 상태 업데이트용
    public var updateMarkerStatus: BloomStatus? = nil

    // MARK: - 기존 init (PIDAFeature에서 사용 - 유지)
    public init(
      flowerSpotData: FlowerSpotEntity,
      bloomingStatus: BloomStatusEntity,
      distance: Double,
      isVotedBlooming: VerifyBloomingStateEntity
    ) {
      self.flowerSpotData = flowerSpotData
      self.bloomingStatus = bloomingStatus
      self.distance = distance
      self.isVotedBlooming = isVotedBlooming
    }

    // MARK: - 신규 init (MapFeature에서 사용 - Phase 3-4)
    /// 빈 초기화 (데이터 로딩 전 상태)
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case showToastView(message: String?)
    case showLoginAlert
    case chechAuth
    case onAppear

    case setFlowerSpotData(FlowerSpotEntity)
    case setBloomingStatus(BloomStatusEntity)
    case setDistance(Double)
    case setVerifyBloomingStatus(VerifyBloomingStateEntity)

    case alertCancelTapped
    case alertAcceptTapped

    // MARK: - 신규 Action (DetailFeature에서 흡수)
    /// 바텀시트 표시 + 데이터 로딩 시작
    case requestDetailInfo(Int)
    /// 데이터만 재로딩 (Blooming 완료 후)
    case fetchDetailInfo(Int)
    /// API 응답 처리
    case detailResponse(FlowerSpotEntity)
    case bloomingResponse(BloomStatusEntity)
    case verifyTodayBlooming(VerifyBloomingStateEntity)

    // MARK: - Delegate
    case delegate(Delegate)
    case dismiss
    case presentToBlooming(id: Int, streetName: String)
  }

  public enum Delegate: Equatable {
    case dismiss
    case presentToBlooming(id: Int, streetName: String)
    case presentToLogin(id: Int)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

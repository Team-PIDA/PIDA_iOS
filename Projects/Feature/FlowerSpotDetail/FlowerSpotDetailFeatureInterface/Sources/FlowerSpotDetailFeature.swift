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

@Reducer
public struct FlowerSpotDetailFeature {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
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

//
//  FlowerSpotDetailReducer.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import ComposableArchitecture
import FlowerSpotDomainInterface
import BloomingDomainInterface

@Reducer
public struct FlowerSpotDetailReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var flowerSpotData: FlowerSpot = .init(
      id: 0,
      recentlyVisitedCount: 0,
      bloomingStatus: .notBloomed,
      streetName: "",
      path: [],
      pinPoint: .init(latitude: 0, longitude: 0),
      region: ""
    )
    public var bloomingStatus: BloomStatusEntity = .init(totalCount: 0, dayStatuses: [])
    public var distance: Double = .zero
    public var toastMessage: String? = nil
    public var isNeedDrawPath: Bool = false
    public var isNeedDeletePath: Bool = false
    public var isShowLoginAlert: Bool = false
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case showToastView(message: String?)
    case showLoginAlert
    case chechAuth
    case onAppear
    
    case alertCancelTapped
    case alertAcceptTapped
    
    // MARK: - Delegate
    case delegate(Delegate)
    case dismiss
    case presentToBlooming(streetName: String)
  }
  
  public enum Delegate: Equatable {
    case dismiss
    case presentToBlooming(streetName: String)
    case presentToLogin
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

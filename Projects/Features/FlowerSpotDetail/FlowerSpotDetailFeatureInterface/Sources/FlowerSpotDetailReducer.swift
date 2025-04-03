//
//  FlowerSpotDetailReducer.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import ComposableArchitecture
import FlowerSpotDomainInterface

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
    public var isNeedDrawPath: Bool = false
    public var isNeedDeletePath: Bool = false
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case delegate(Delegate)
    case dismiss
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

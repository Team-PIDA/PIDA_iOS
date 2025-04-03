//
//  BloomingUpdateReducer.swift
//  BloomingFeatureInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import DesignKit

@Reducer
public struct BloomingUpdateReducer {
  private let reducer: Reduce<State, Action>
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var streetName: String = ""
    public var spotId: Int? = nil
    public var isButtonEnable: Bool = false
    public var buttonTittle: String = "개화 상태를 선택해주세요"
    public var selectedStatus: BloomStatus? = nil
    public var toastMessage: String? = nil
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case changeStatus
    case initialState
    case sendToastMessage(String)
    
    case updateButtonTapped
    case updateBloomingRequest
    
    case setSpodtId(Int)
    case setStreetName(String)
    
    case delegate(Delegate)
    case dismiss(didUpdate: Bool) // 상태 기록 완료 여부
  }
  
  public enum Delegate: Equatable {
    case dismiss(didUpdate: Bool)
  }
  
  public enum ID: Hashable {
    case throttle
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}


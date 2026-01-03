//
//  LocationFeature.swift
//  MapFeature
//
//  Created by Jiyeon on 4/7/25.
//  Copyright © 2025 com.pida.me.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import DesignKit
import FlowerSpotClient
import Shared

@Reducer
public struct LocationFeature {
  private let reducer: Reduce<State, Action>
  
  public init(
    reducer: Reduce<State, Action>,
  ) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var isCurrentButtonTap: Bool = false
    /// 특정 지점으로 이동하기 위한 위치정보
    public var point: Coordinate? = nil
    /// 유저의 현재 위치
    public var userLocation: Coordinate? = nil
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case moveUserLocation
    case saveUserLocation(Coordinate)
    case moveLocation(Coordinate)
    
    case currentButtonTapped(Bool)
    
    case fetchFlowers([Coordinate])
    case storeFlowerData([FlowerSpotEntity])
    
    case mapSearchError(String?)
    case showToastView(message: String?, buttonLabel: String?)
    case presentAlert(type: AlertType)
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case storeFlowerData([FlowerSpotEntity])
    /// 상위로 전달하여 하위 state에 동기화
    case storeUserLocation(Coordinate?)
    
    case showToastView(message: String?, buttonLabel: String?)
    case presentAlert(type: AlertType)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
    
  }
  
}



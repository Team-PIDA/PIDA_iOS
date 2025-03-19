//
//  TempView.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/19/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct TempView: View {
  var store: StoreOf<TempReducer>
  public init(store: StoreOf<TempReducer>) {
    self.store = store
  }
    public var body: some View {
        Text("HELLO")
    }
}

@Reducer
public struct TempReducer {
  public struct State: Equatable {
    public init() {}
  }
  public enum Action {
    
  }
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      return .none
    }
  }
}

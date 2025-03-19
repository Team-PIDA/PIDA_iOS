//
//  MapRootView.swift
//  MapDemo
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Sample1FeatureInterface

public struct MapRootView: View {
  @Bindable var store: StoreOf<MapRootReducer>
  
  public init(store: StoreOf<MapRootReducer>) {
    self.store = store
  }
  
  public var body: some View {
    
    NavigationStack(path: $store.path) {
      MapView(store: store.scope(state: \.map, action: \.map))
        .navigationDestination(for: MapPath.self) { path in
          switch path {
          case .setting:
            Sample1View(store: store.scope(state: \.sample, action: \.sample))
          case .search:
            Sample1View(store: store.scope(state: \.sample, action: \.sample))
          }
        }
        .fullScreenCover(isPresented: $store.isShowDetails) {
          Sample1View(store: store.scope(state: \.sample, action: \.sample))
        }
    }

  }
}

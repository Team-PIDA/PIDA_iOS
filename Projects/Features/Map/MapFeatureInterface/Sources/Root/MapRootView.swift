//
//  MapRootView.swift
//  MapDemo
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct MapRootView: View {
  @Bindable var store: StoreOf<MapRootReducer>
  
  public init(store: StoreOf<MapRootReducer>) {
    self.store = store
  }
  
  public var body: some View {
    
    NavigationStack(path: $store.path) {
      MapView(store: store.scope(state: \.map, action: \.map))
        .navigationDestination(for: MapPath.self) { path in
          
        }
        .fullScreenCover(isPresented: $store.isShowSearch) {
          EmptyView()
        }
        .transaction { transaction in
          transaction.disablesAnimations = true
        }
    }

  }
}

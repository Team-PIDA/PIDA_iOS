//
//  PIDAView.swift
//  PIDA
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import MapFeatureInterface
import SearchFeatureInterface

struct PIDAView: View {
  @Bindable var store: StoreOf<PIDAReducer> = Store(initialState: PIDAReducer.State()) { PIDAReducer()
  }
  var body: some View {
    NavigationStack(path: $store.path) {
      MapView(store: store.scope(state: \.map, action: \.map))
        .navigationDestination(for: Path.self) { path in
          
        }
        .fullScreenCover(isPresented: $store.isShowSearch) {
          SearchView(store: store.scope(state: \.search, action: \.search))
        }
        .transaction { transaction in
          transaction.disablesAnimations = true
        }
    }
  }

}

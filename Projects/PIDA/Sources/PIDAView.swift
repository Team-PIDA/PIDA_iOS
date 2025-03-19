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

struct PIDAView: View {
  @Bindable var store: StoreOf<PIDAReducer> = Store(initialState: PIDAReducer.State()) { PIDAReducer() }
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      MapView(store: store.scope(state: \.map, action: \.map))
    } destination: { store in
      NavigationHandler(store: store)
    }
    
  }
}

#Preview {
  PIDAView()
}

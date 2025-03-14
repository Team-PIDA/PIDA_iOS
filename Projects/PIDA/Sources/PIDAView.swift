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
import MapFeature

struct PIDAView: View {
  private let store: StoreOf<PIDAReducer> = Store(initialState: PIDAReducer.State()) {
    PIDAReducer()
  }
  private let mapFeature: MapInterface = MapFeature()
  
  var body: some View {
    mapFeature.startView(store: store.scope(state: \.mapView, action: \.mapView))
  }
}

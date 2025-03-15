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
  private let store: StoreOf<PIDAReducer> = Store(initialState: PIDAReducer.State()) { PIDAReducer() }
  private var mapFeature: MapInterface {
    MapFeature(reducer: store.scope(state: \.mapView, action: \.mapView))
  }
  
  var body: some View {
    mapFeature.startView()
  }
}

//
//  MapView.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import MapFeatureInterface
import ComposableArchitecture

public struct MapView: View {
  let store: StoreOf<MapReducer> = Store(initialState: MapReducer.State(), reducer: {
    MapReducer()
  })
  
//  public init(store: StoreOf<MapReducer>) {
//    self.store = store
//  }
  public init() { }
  
  public var body: some View {
    Text(store.state.text)
    Button {
      store.send(.events)
    } label: {
      Text("Text")
    }

  }
}

//#Preview {
//  MapView(store: Store(initialState: MapReducer.State(), reducer: {
//    MapReducer()
//  }))
//}

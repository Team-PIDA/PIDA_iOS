//
//  FlowerSpotDetailView.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

public struct FlowerSpotDetailView: View {
  let store: StoreOf<FlowerSpotDetailReducer>

  public init(store: StoreOf<FlowerSpotDetailReducer>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


//
//  BloomingView.swift
//
//  Blooming
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public struct BloomingView: View {
  let store: StoreOf<BloomingReducer>

  public init(store: StoreOf<BloomingReducer>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


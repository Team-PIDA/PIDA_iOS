//
//  Sample2View.swift
//
//  Sample2
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public struct Sample2View: View {
  let store: StoreOf<Sample2Reducer>

  public init(store: StoreOf<Sample2Reducer>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


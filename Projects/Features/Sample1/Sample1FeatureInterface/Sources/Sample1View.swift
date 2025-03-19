//
//  Sample1View.swift
//
//  Sample1
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public struct Sample1View: View {
  let store: StoreOf<Sample1Reducer>

  public init(store: StoreOf<Sample1Reducer>) {
    self.store = store
  }

  public var body: some View {
    Color.brown.opacity(0.5)
    
  }
}


//
//  SearchView.swift
//
//  Search
//
//  Created by JiYeon
//

import SwiftUI
import DesignKit

import ComposableArchitecture

public struct SearchView: View {
  @Bindable var store: StoreOf<SearchReducer>

  public init(store: StoreOf<SearchReducer>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


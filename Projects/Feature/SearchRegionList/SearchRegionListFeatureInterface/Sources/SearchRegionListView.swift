//
//  SearchRegionListView.swift
//
//  SearchRegionList
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

public struct SearchRegionListView: View {
  let store: StoreOf<SearchRegionListFeature>

  public init(store: StoreOf<SearchRegionListFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}

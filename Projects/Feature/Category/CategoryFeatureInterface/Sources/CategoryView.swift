//
//  CategoryView.swift
//
//  Category
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

public struct CategoryView: View {
  let store: StoreOf<CategoryFeature>

  public init(store: StoreOf<CategoryFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}

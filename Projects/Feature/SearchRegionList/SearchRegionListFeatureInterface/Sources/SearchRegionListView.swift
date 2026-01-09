//
//  SearchRegionListView.swift
//
//  SearchRegionList
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct SearchRegionListView: View {
  let store: StoreOf<SearchRegionListFeature>

  public init(store: StoreOf<SearchRegionListFeature>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      headerView
      Spacer()
    }
  }
  
  @ViewBuilder
  private var headerView: some View {
    VStack {
      Text(store.regionName + " 근처 벚꽃길")
        .fontStyle(FontSet.Heading.heading3)
        .foregroundStyle(ColorSet.Text.Primary)
        .padding(.horizontal, .Number16)
        .padding(.top, .Number16)
        .padding(.bottom, .Number12)
    }
  }
}

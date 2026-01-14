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
    VStack(alignment: .leading, spacing: 0) {
      headerView
      
      ScrollView {
        LazyVStack(spacing: .Number12) {
          ForEach(0..<20, id: \.self) { _ in
            RegionListItemView()
              .padding(.horizontal, .Number16)
          }
        }
        .padding(.top, .Number8)
        .padding(.bottom, .Number16)
      }
    }
  }
  
  @ViewBuilder
  private var headerView: some View {
    VStack(alignment: .leading) {
      Text(store.region.name + " 근처 벚꽃길")
        .fontStyle(FontSet.Heading.heading3)
        .foregroundStyle(ColorSet.Text.Primary)
        .padding(.horizontal, .Number16)
        .padding(.top, .Number16)
        .padding(.bottom, .Number12)
      
    }
  }
}

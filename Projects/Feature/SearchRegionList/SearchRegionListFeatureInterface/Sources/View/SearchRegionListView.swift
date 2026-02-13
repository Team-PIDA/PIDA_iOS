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
import DotLottie

public struct SearchRegionListView: View {
  let store: StoreOf<SearchRegionListFeature>

  public init(store: StoreOf<SearchRegionListFeature>) {
    self.store = store
  }

  public var body: some View {
    if store.isLoading {
      VStack(alignment: .center) {
        Spacer()
        DotLottieAnimation(
          fileName: LottieSet.dot_loading.name,
          bundle: DesignKitResources.bundle,
          config: AnimationConfig(autoplay: true, loop: true)
        )
        .view()
        .frame(width: .Number100, height: .Number100)
        Spacer()
      }
    } else {
      content
        .onAppear {
          store.send(.onAppear)
        }
    }
  }
  
  @ViewBuilder
  private var content: some View {
    VStack(alignment: .leading, spacing: 0) {
      headerView
      
      ScrollView {
        if store.isDataEmpty {
          emptyView
        } else {
          LazyVStack(spacing: .Number0) {
            ForEach(store.flowerSpots, id: \.id) { flowerSpot in
              RegionListItemView(
                flowerSpot: flowerSpot,
                onTap: { flowerSpot in
                  store.send(.flowerSpotTapped(flowerSpot))
                }
              )
              .padding(.horizontal, .Number16)
            }
          }
          .padding(.top, .Number8)
          .padding(.bottom, .Number16)
        }
      }
    }
  }
  
  @ViewBuilder
  private var emptyView: some View {
    VStack(alignment: .center, spacing: .Number8) {
      Spacer()
      Image(asset: ImageSet.emptyResult.swiftUIImage)
      Text("검색 결과가 없습니다.")
        .fontStyle(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .frame(minHeight: 300)
    
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

//
//  CategoryView.swift
//
//  Category
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import DotLottie
import FlowerSpotClient

public struct CategoryListView: View {
  let store: StoreOf<CategoryListFeature>

  public init(store: StoreOf<CategoryListFeature>) {
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
      categoryScrollView

      ScrollView {
        if store.isDataEmpty {
          emptyView
        } else {
          LazyVStack(spacing: .Number0) {
            ForEach(store.flowerSpots, id: \.id) { flowerSpot in
              flowerSpotItemView(flowerSpot)
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
  private var headerView: some View {
    VStack(alignment: .leading) {
      Text(selectedCategoryTitle + " 벚꽃길")
        .fontStyle(FontSet.Heading.heading3)
        .foregroundStyle(ColorSet.Text.Primary)
        .padding(.horizontal, .Number16)
        .padding(.top, .Number16)
        .padding(.bottom, .Number12)
    }
  }

  @ViewBuilder
  private var categoryScrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: .Number8) {
        ForEach(store.categoryList, id: \.id) { item in
          CategoryButton(
            title: item.title,
            isActive: item.id == store.selectedCategoryId
          )
          .onTapGesture {
            store.send(.tapCategory(id: item.id))
          }
        }
      }
      .padding(.horizontal, .Number16)
    }
    .padding(.bottom, .Number12)
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
  private func flowerSpotItemView(_ flowerSpot: FlowerSpotEntity) -> some View {
    VStack(alignment: .leading, spacing: .Number0) {
      HStack(alignment: .center, spacing: .Number12) {
        HStack {
          VStack(alignment: .leading, spacing: .Number0) {
            Text(flowerSpot.streetName)
              .fontStyle(FontSet.Body.body2)
              .foregroundStyle(ColorSet.Text.Primary)
            Text(flowerSpot.address)
              .fontStyle(FontSet.Caption.caption1)
              .foregroundStyle(ColorSet.Text.Tertiary)
            HStack(spacing: .Number4) {
              if let bloomStatus = BloomStatus(rawValue: flowerSpot.bloomingStatus) {
                BloomStateTagView(state: bloomStatus)
              }
              TagView(text: flowerSpot.recentlyVisitedCountString)
            }
            .padding(.top, .Number8)
          }
          Spacer()
        }

        if let previewUrl = flowerSpot.previewUrl {
          RemoteImageView(urlString: previewUrl)
            .frame(width: 72, height: 72)
            .clipped()
            .cornerRadius(.Number16)
        }
      }
      .padding(.vertical, .Number12)
      BorderView(size: .long)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      store.send(.flowerSpotTapped(flowerSpot))
    }
  }

  private var selectedCategoryTitle: String {
    store.categoryList.first { $0.id == store.selectedCategoryId }?.title ?? ""
  }
}

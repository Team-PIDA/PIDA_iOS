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

public struct CategoryListView: View {
  let store: StoreOf<CategoryListFeature>

  public init(store: StoreOf<CategoryListFeature>) {
    self.store = store
  }

  public var body: some View {
    Group {
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
            ForEach(store.categoryItems, id: \.id) { item in
              CategoryListItemView(
                type: store.categoryType,
                item: item,
                onTap: { item in
                  store.send(.spotTapped(spotId: item.id))
                }
              )
              .padding(.horizontal, .Number16)
            }
          }
          .padding(.bottom, .Number16)
        }
      }
    }
  }

  @ViewBuilder
  private var headerView: some View {
    VStack(alignment: .leading) {
      Text(store.headerTitle)
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
        ForEach(store.filterList, id: \.id) { item in
          CategoryButton(
            title: item.title,
            isActive: item.id == store.selectedFilterId
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

}

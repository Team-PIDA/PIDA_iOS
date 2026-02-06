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
  @Bindable var store: StoreOf<SearchFeature>
  
  public init(store: StoreOf<SearchFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack {
        searchView()
        searchList()
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

extension SearchView {
  /// 검색 리스트
  private func searchList() -> some View {
    VStack(alignment: .leading, spacing: .Number0) {
      if store.showRecentList {
        Text("최근검색")
          .fontStyle(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .padding(.horizontal, .Number16)
          .padding(.top, .Number8)
          .padding(.bottom, .Number4)
      }
      
      if store.searchList.isEmpty {
        Spacer()
        emptyResultView
        Spacer()
      } else {
        ScrollView {
          LazyVStack {
            ForEach(store.searchList, id: \.identifier) { data in
              SearchResultList(
                item: data,
                onTap: {
                  store.send(.selectResult($0))
                }
              )
            }
          }
        }
      }
    }
  }
  
  /// SearchBar
  private func searchView() -> some View {
    SearchBar(
      text: $store.searchWord.removeDuplicates(),
      placeholder: "방문할 장소를 입력하세요",
      mode: .search,
      isFocused: $store.isFocused,
      leadingContent: {
        TouchArea(image: .back)
          .size(.extraLarge)
          .action {
            store.send(.dismiss)
          }
      }
    )
    
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number8)
  }
  
  private var emptyResultView: some View {
    HStack {
      Spacer()
      VStack(alignment: .center, spacing: .Number8) {
        Image(asset: ImageSet.emptyResult.swiftUIImage)
        Text("최근 검색 결과가 없습니다.")
          .fontStyle(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
      }
      Spacer()
    }

  }
}

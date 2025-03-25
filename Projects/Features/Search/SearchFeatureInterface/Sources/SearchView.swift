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
  // TODO: - 검색 데이터 확정 시 데이터에 맞춰 파라미터 추가
  /// 검색 리스트
  private func searchList() -> some View {
    ScrollView {
      LazyVStack {
        ForEach(0..<10) { index in
          SearchResultList(
            id: index,
            roadName: "석촌호수길",
            address: "서울 송파구 잠실동",
            subInfo: "10km",
            onTap: { _ in
              store.send(.selectResult("석촌호수길"))
            }
          )
        }
      }
    }
  }
  
  /// SearchBar
  private func searchView() -> some View {
    SearchBar(
      text: $store.searchWord,
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
    .onSubmit { 
      store.send(.selectResult(store.searchWord))
    }
    
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number8)
  }
}

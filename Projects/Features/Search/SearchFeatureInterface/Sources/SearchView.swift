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
enum FocusField: Hashable {
  case field
}
public struct SearchView: View {
  @Bindable var store: StoreOf<SearchReducer>
  
  public init(store: StoreOf<SearchReducer>) {
    self.store = store
    
  }
  @State var text: String = ""
  public var body: some View {
    VStack {
      searchView()
      searchList()
    }
    .onAppear {
      store.send(.onAppear)
    }
    
  }
}

extension SearchView {
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
  
  private func searchView() -> some View {
    SearchBar(
      text: $store.searchWord,
      placeholder: "방문할 장소를 입력하세요",
      mode: .searchable,
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

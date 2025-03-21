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
      Spacer()
    }
    .onAppear {
      store.send(.onAppear)
    }
    
  }
}

extension SearchView {
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
      print("hello")
    }
    
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number8)
  }
}

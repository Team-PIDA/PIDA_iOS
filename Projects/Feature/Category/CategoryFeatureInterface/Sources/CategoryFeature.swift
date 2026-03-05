//
//  CategoryFeature.swift
//  CategoryFeatureInterface
//
//  Created by Jiyeon on 3/4/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct CategoryFeature {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  @ObservableState
  public struct State: Equatable {
    public var selectedCategoryId: Int = 1
    public var categoryList: [CategoryItem]
    public init() {
      categoryList = [
        .init(id: 1, title: "전체"),
        .init(id: 2, title: "산책로 추천"),
        .init(id: 3, title: "카페 추천"),
        .init(id: 4, title: "벚꽃 축제")
      ]
    }
  }

  public enum Action: Equatable {
    case tapCategory(id: Int)
    case resetToAll
    case delegate(Delegate)
  }

  public enum Delegate: Equatable {
    case tapCategory(title: String)
    case resetCategory
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}

public struct CategoryItem: Equatable {
  public var id: Int
  public var title: String
}

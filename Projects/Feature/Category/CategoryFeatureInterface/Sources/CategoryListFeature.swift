//
//  CategoryFeature.swift
//  CategoryFeatureInterface
//
//  Created by Jiyeon on 3/4/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import FlowerSpotClient

@Reducer
public struct CategoryListFeature {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  @ObservableState
  public struct State: Equatable {
    public var selectedCategoryId: Int = 1
    public var categoryList: [CategoryListItem]
    public var flowerSpots: [FlowerSpotEntity] = []
    public var isLoading: Bool = true
    public var isDataEmpty: Bool = false

    public init() {
      categoryList = [
        .init(id: 1, title: "전체"),
        .init(id: 2, title: "서울"),
        .init(id: 3, title: "경기"),
        .init(id: 4, title: "인천"),
        .init(id: 5, title: "강원"),
        .init(id: 6, title: "충북")
      ]
    }
  }

  public enum Action: Equatable {
    case onAppear
    case tapCategory(id: Int)
    case resetToAll
    case storeFlowerSpots([FlowerSpotEntity])
    case flowerSpotTapped(id: Int)
    case delegate(Delegate)
  }

  public enum Delegate: Equatable {
    case tapCategory(title: String)
    case showFlowerSpotDetail(FlowerSpotEntity)
    case requestFlowerSpots(title: String)
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}

public struct CategoryListItem: Equatable {
  public var id: Int
  public var title: String

  public init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}

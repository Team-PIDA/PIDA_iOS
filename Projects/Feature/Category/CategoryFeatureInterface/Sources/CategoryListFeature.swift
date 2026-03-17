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
import CategoryClient

@Reducer
public struct CategoryListFeature {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  @ObservableState
  public struct State: Equatable {
    public var selectedFilterId: Int = 1
    public var headerTitle: String = ""
    public var categoryItem: CategoryEntity
    public var filterList: [CategoryListItem] = []
    public var flowerSpots: [FlowerSpotEntity] = []
    public var isLoading: Bool = true
    public var isDataEmpty: Bool = false

    public init(categoryItem: CategoryEntity) {
      self.categoryItem = categoryItem
      if categoryItem.type == .event {
        filterList = [
          .init(id: 1, title: "전체"),
          .init(id: 2, title: "서울"),
          .init(id: 3, title: "경기"),
          .init(id: 4, title: "인천"),
          .init(id: 5, title: "강원"),
          .init(id: 6, title: "충북")
        ]
      }
    }
  }

  public enum Action: Equatable {
    case tapCategory(id: Int)
    case storeSpots([FlowerSpotEntity])
    case spotTapped(id: Int)
    case delegate(Delegate)
  }

  public enum Delegate: Equatable {
    case showFlowerSpotDetail(FlowerSpotEntity)
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

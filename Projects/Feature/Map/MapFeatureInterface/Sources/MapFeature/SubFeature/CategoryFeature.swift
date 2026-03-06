//
//  CategoryFeature.swift
//  MapFeatureInterface
//
//  Created by Jiyeon
//

import Foundation
import ComposableArchitecture
import DesignKit
import FlowerSpotClient

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

    public var isShowCategoryList: Bool = false
    public var categoryListDetent: BottomSheetDetent = .medium
    public var categoryListBottomSheetHeight: CGFloat = 0

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
    case changeCategorySheetDetent
    case fetchFlowerSpots(title: String)
    case delegate(Delegate)
  }

  public enum Delegate: Equatable {
    case tapCategory(title: String)
    case resetCategory
    case didFetchFlowerSpots([FlowerSpotEntity])
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}

public struct CategoryItem: Equatable {
  public var id: Int
  public var title: String

  public init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}

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
import CategoryClient

@Reducer
public struct CategoryFeature {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  @ObservableState
  public struct State: Equatable {
    public var selectedCategory: CategoryType = .all
    public var categoryList: [CategoryEntity] = []

    public var isShowCategoryList: Bool = false
    public var categoryListDetent: BottomSheetDetent = .medium
    public var categoryListBottomSheetHeight: CGFloat = 0

    public init() {
      
    }
  }

  public enum Action: Equatable {
    case fetchCategoryList
    case storeCategoryList([CategoryEntity])
    case tapCategory(CategoryType)
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

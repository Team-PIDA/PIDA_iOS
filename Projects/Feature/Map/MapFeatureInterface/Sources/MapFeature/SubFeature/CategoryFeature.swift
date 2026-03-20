//
//  CategoryFeature.swift
//  MapFeatureInterface
//
//  Created by Jiyeon
//

import Foundation
import ComposableArchitecture
import DesignKit
import CategoryClient
import Shared

@Reducer
public struct CategoryFeature {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  @ObservableState
  public struct State: Equatable {
    public var selectedCategory: CategoryType = .all
    public var selectedCategoryId: Int? = nil
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
    case tapCategory(CategoryEntity)
    case storeRegionList([RegionEntity], CategoryEntity)
    case resetToAll
    case changeCategorySheetDetent
    case fetchCategorySpots(sw: Coordinate?, ne: Coordinate?)
    case fetchEventCategoryItems(region: Region?)
    case errorLog(String)
    case delegate(Delegate)
  }

  public enum Delegate: Equatable {
    case tapCategory(CategoryEntity, [RegionEntity])
    case resetCategory
    case didFetchCategoryItems(CategoryItemListEntity)
    case requestMapBounds
  }

  public enum CancelID {
    case fetchCategoryItems
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}

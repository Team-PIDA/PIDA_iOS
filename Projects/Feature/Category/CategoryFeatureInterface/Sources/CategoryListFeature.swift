//
//  CategoryFeature.swift
//  CategoryFeatureInterface
//
//  Created by Jiyeon on 3/4/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import CategoryClient
import Shared

@Reducer
public struct CategoryListFeature {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  @ObservableState
  public struct State: Equatable {
    public var selectedFilter: Region? = nil
    public var headerTitle: String = ""
    public var categoryItem: CategoryEntity
    public var regionFilterList: [RegionEntity] = []
    public var categoryItems: [CategoryItemEntity] = []
    public var categoryId: Int? = nil
    public var categoryType: CategoryType? = nil
    public var isLoading: Bool = true
    public var isDataEmpty: Bool = false

    public init(categoryItem: CategoryEntity, regionList: [RegionEntity] = [], initialFilter: Region? = nil) {
      self.categoryItem = categoryItem
      self.selectedFilter = initialFilter
      if categoryItem.type == .event {
        regionFilterList = [.init(code: nil, name: "전체")] + regionList
      }
    }
  }

  public enum Action: Equatable {
    case tapFilter(RegionEntity)
    case storeCategoryItems(CategoryItemListEntity)
    case spotTapped(spotId: Int)
    case delegate(Delegate)
  }

  public enum Delegate: Equatable {
    case showCategoryDetail(spotId: Int)
    case showEmptyToast(message: String, buttonLabel: String?)
    case refetchItemsWithRegion(RegionEntity)
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}

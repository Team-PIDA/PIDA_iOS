//
//  CategoryClient.swift
//  CategoryClient
//
//  Created by PIDA on 3/11/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import APIClient

@DependencyClient
public struct CategoryClient: Sendable {
  public var fetchCategories: @Sendable () async throws -> [CategoryEntity]
  public var fetchCategoryItems: @Sendable (_ id: Int, _ query: GetCategoryItemsQuery) async throws -> CategoryItemListEntity
  public var fetchCategoryItemDetail: @Sendable (_ categoryId: Int, _ itemId: Int) async throws -> CategoryItemDetailEntity
  public var fetchRegionList: @Sendable () async throws -> [RegionEntity]
}

public extension DependencyValues {
  var categoryClient: CategoryClient {
    get { self[CategoryClient.self] }
    set { self[CategoryClient.self] = newValue }
  }
}

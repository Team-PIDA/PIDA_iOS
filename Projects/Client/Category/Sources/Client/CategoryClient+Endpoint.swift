//
//  CategoryClient+Endpoint.swift
//  CategoryClient
//
//  Created by PIDA on 3/11/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient
import Shared

struct CategoryEndpoint: Sendable {
  static func getCategories() -> Endpoint<CategoryListDTO> {
    return Endpoint(
      method: .get,
      baseURL: Constant.base_url_v2 ?? "",
      path: "/categories"
    )
  }

  static func getCategoryItems(
    categoryId: Int,
    query: GetCategoryItemsQuery
  ) -> Endpoint<CategoryItemListDTO> {
    return Endpoint(
      method: .get,
      baseURL: Constant.base_url_v2 ?? "",
      path: "/categories/\(categoryId)/items",
      parameters: .query(query)
    )
  }

  static func getCategoryItemDetail(
    categoryId: Int,
    itemId: Int
  ) -> Endpoint<CategoryItemDetailDTO> {
    return Endpoint(
      method: .get,
      baseURL: Constant.base_url_v2 ?? "",
      path: "/categories/\(categoryId)/items/\(itemId)"
    )
  }
  
  static func getRegionList() -> Endpoint<RegionListDTO> {
    return Endpoint(
      method: .get,
      path: "/regions"
    )
  }
}

//
//  CategoryClient+Live.swift
//  CategoryClient
//
//  Created by PIDA on 3/11/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import APIClient

extension CategoryClient: DependencyKey {
  public static var liveValue: CategoryClient {
    @Dependency(\.apiClient) var apiClient

    return .init(
      fetchCategories: {
        let endpoint = CategoryEndpoint.getCategories()
        return try await apiClient.execute(endpoint).toEntity()
      },
      fetchCategoryItems: { id, query in
        let endpoint = CategoryEndpoint.getCategoryItems(categoryId: id, query: query)
        return try await apiClient.execute(endpoint).toEntity()
      }
    )
    
  }
}

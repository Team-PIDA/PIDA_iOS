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
        return [
          CategoryEntity(id: 1, title: "벚꽃 축제", label: "EVENT"),
          CategoryEntity(id: 2, title: "산책로 추천", label: "TRAIL"),
          CategoryEntity(id: 3, title: "카페 추천", label: "CAFE"),
        ]
      }
    )
  }
}

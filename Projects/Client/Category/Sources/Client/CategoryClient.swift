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
}

public extension DependencyValues {
  var categoryClient: CategoryClient {
    get { self[CategoryClient.self] }
    set { self[CategoryClient.self] = newValue }
  }
}

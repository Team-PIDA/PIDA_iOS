//
//  CategoryEntity.swift
//  CategoryClient
//
//  Created by PIDA on 3/11/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public struct CategoryEntity: Equatable, Sendable, Identifiable {
  public let id: Int
  public let category: String
  public let type: CategoryType

  public init(id: Int, category: String) {
    self.id = id
    self.category = category
    self.type = CategoryType(rawValue: id)
  }
}

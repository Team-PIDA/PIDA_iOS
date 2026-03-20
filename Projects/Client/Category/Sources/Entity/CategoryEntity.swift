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
  public let title: String
  public let type: CategoryType

  public init(id: Int, title: String, label: String) {
    self.id = id
    self.title = title
    self.type = CategoryType(rawValue: label)
  }
}

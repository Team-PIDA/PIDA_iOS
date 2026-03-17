//
//  CategoryListDTO.swift
//  CategoryClient
//
//  Created by PIDA on 3/11/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient

struct CategoryListDTO: DTO {
  typealias Entity = [CategoryEntity]

  var list: [CategoryItemDTO]?
}

extension CategoryListDTO {
  func toEntity() throws -> [CategoryEntity] {
    return list?.map { $0.toEntity() } ?? []
  }
}

struct CategoryItemDTO: Codable {
  var id: Int
  var category: String

  func toEntity() -> CategoryEntity {
    CategoryEntity(id: id, category: category)
  }
}

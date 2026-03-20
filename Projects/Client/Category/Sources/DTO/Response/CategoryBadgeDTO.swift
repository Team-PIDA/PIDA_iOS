//
//  CategoryBadgeDTO.swift
//  CategoryClient
//
//  Created by Jiyeon on 3/20/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient

struct CategoryBadgeDTO: DTO {
  var type: String
  var label: String

  func toEntity() throws -> CategoryBadgeEntity {
    CategoryBadgeEntity(type: type, label: label)
  }
}

//
//  CategoryClient+Endpoint.swift
//  CategoryClient
//
//  Created by PIDA on 3/11/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient

struct CategoryEndpoint: Sendable {
  @discardableResult
  static func getCategories() -> Endpoint<CategoryListDTO> {
    return Endpoint(
      method: .get,
      path: "/categories"
    )
  }
}

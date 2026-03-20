//
//  GetCategoryItemsQuery.swift
//  CategoryClient
//
//  Created by Jiyeon on 3/19/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public struct GetCategoryItemsQuery: Encodable {
  public let swLat: Double?
  public let swLng: Double?
  public let neLat: Double?
  public let neLng: Double?
  public let region: String?

  public init(
    swLat: Double? = nil,
    swLng: Double? = nil,
    neLat: Double? = nil,
    neLng: Double? = nil,
    region: String? = nil
  ) {
    self.swLat = swLat
    self.swLng = swLng
    self.neLat = neLat
    self.neLng = neLng
    self.region = region
  }
}

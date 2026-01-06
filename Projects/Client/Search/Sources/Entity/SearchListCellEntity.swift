//
//  SearchListCellEntity.swift
//  SearchClient
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import CacheClient

public struct SearchListCellEntity: Equatable, Sendable, Codable {
  public let id: Int
  public let address: String?
  public let streetName: String?
  public let subInfo: String?
  
  public init(
    id: Int,
    address: String?,
    streetName: String?,
    subInfo: String? = nil
  ) {
    self.id = id
    self.address = address
    self.streetName = streetName
    self.subInfo = subInfo
  }
  
  public init(_ entity: SearchAddressCacheModel) {
    self.id = entity.id
    self.address = entity.address
    self.streetName = entity.streetName
    self.subInfo = entity.subInfo
  }
  
}

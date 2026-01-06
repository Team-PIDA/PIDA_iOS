//
//  SearchAddressCacheModel.swift
//  CacheClient
//
//  Created by Jiyeon on 1/6/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public struct SearchAddressCacheModel: Equatable, Sendable, Codable {
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
}

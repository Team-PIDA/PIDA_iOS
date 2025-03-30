//
//  SearchListCellEntity.swift
//  SearchDomainInterface
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct SearchListCellEntity: Equatable, Sendable {
  public let id: Int
  public let address: String?
  public let streetName: String?
  
  public init(
    id: Int,
    address: String?,
    streetName: String?
  ) {
    self.id = id
    self.address = address
    self.streetName = streetName
  }
}

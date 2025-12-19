//
//  VerifyBloomingStateDTO.swift
//  BloomingDataInterface
//
//  Created by 조용인 on 4/4/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import BloomingDomainInterface
import Networker

public struct VerifyBloomingStateDTO: DTO {
  public typealias Entity = VerifyBloomingStateEntity
  
  public let isBlooming: Bool
  
  public init(isBlooming: Bool) {
    self.isBlooming = isBlooming
  }
}

extension VerifyBloomingStateDTO {
  public func toEntity() throws -> VerifyBloomingStateEntity {
    return .init(isBlooming: isBlooming)
  }
}

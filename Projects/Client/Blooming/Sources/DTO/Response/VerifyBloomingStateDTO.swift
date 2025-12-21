//
//  VerifyBloomingStateDTO.swift
//  BloomingDataInterface
//
//  Created by 조용인 on 4/4/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient

struct VerifyBloomingStateDTO: DTO {
  typealias Entity = VerifyBloomingStateEntity
  
  let isBlooming: Bool
  
  init(isBlooming: Bool) {
    self.isBlooming = isBlooming
  }
}

extension VerifyBloomingStateDTO {
  func toEntity() throws -> VerifyBloomingStateEntity {
    return .init(isBlooming: isBlooming)
  }
}

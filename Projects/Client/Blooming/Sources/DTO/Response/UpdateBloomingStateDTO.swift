//
//  UpdateBloomingStateDTO.swift
//  BloomingClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import APIClient

struct UpdateBloomingStateDTO: DTO {
  typealias Entity = UpdateBloomingStateEntity
  
  let message: String
  
  init(message: String) {
    self.message = message
  }
}

extension UpdateBloomingStateDTO {
  func toEntity() throws -> Entity {
    return .init(message: message)
  }
}

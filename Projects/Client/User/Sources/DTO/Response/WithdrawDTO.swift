//
//  WithdrawDTO.swift
//  UserDataInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient

struct WithdrawDTO: DTO {
  typealias Entity = WithDrawEntity
  
  let message: String
  
  init(message: String) {
    self.message = message
  }
}

extension WithdrawDTO {
  func toEntity() throws -> Entity {
    return .init(
      message: message
    )
  }
}

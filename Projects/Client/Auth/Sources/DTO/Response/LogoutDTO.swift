//
//  LogoutDTO.swift
//  AuthClient
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient

struct LogoutDTO: DTO {
  typealias Entity = LogoutEntity
  
  let message: String
  
  init(message: String) {
    self.message = message
  }
}

extension LogoutDTO {
  func toEntity() -> Entity {
    return .init(message: message)
  }
}

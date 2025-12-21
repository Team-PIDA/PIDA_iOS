//
//  SignUpDTO.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient

struct SignUpDTO: DTO {
  typealias Entity = SignUpEntity
  
  let message: String
  
  init(message: String) {
    self.message = message
  }
  
}

extension SignUpDTO {
  func toEntity() throws -> SignUpEntity {
    return .init(message: message)
  }
}

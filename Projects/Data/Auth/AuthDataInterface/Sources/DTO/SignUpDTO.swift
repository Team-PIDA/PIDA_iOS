//
//  SignUpDTO.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface
import Networker

public struct SignUpDTO: DTO {
  public typealias Entity = SignUpEntity
  let message: String
  
  public init(message: String) {
    self.message = message
  }
  
  public func toEntity() throws -> SignUpEntity {
    return .init(message: message)
  }
}

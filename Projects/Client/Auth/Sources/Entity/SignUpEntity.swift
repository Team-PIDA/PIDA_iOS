//
//  SignUpEntity.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct SignUpEntity: Sendable, Equatable {
  
  public let message: String
  
  public init(message: String) {
    self.message = message
  }
}

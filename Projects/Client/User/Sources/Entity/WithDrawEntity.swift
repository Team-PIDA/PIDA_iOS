//
//  WithDrawEntity.swift
//  UserClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation

public struct WithDrawEntity: Sendable, Equatable {
  public var message: String
  
  public init(message: String) {
    self.message = message
  }
}

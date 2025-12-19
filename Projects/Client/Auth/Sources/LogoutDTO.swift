//
//  LogoutDTO.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker

public struct LogoutDTO: DTO {
  public typealias Entity = Void
  let message: String
  
  public init(message: String) {
    self.message = message
  }
  
  public func toEntity() throws -> Void {}
}

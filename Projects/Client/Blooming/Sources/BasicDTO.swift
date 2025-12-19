//
//  BasicDTO.swift
//  BloomingDataInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker

public struct BasicDTO: DTO {
  public typealias Entity = Void
  
  let message: String
  public init(message: String) {
    self.message = message
  }
}

extension BasicDTO {
  public func toEntity() throws -> Void {}
}

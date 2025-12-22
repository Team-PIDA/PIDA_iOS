//
//  VerifyBloomingStateEntity.swift
//  BloomingClient
//
//  Created by 조용인 on 4/4/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct VerifyBloomingStateEntity: Sendable, Equatable {
  public let isBlooming: Bool
  
  public init(isBlooming: Bool) {
    self.isBlooming = isBlooming
  }
}

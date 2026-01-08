//
//  UpdateBloomingStateEntity.swift
//  BloomingClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation

public struct UpdateBloomingStateEntity: Sendable, Equatable {
  public let message: String
  public let uploadUrl: String?
  public let imageUrl: String?

  public init(
    message: String,
    uploadUrl: String? = nil,
    imageUrl: String? = nil
  ) {
    self.message = message
    self.uploadUrl = uploadUrl
    self.imageUrl = imageUrl
  }
}

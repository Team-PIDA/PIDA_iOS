//
//  UpdateBloomingStateDTO.swift
//  BloomingClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import APIClient

struct UpdateBloomingStateDTO: DTO {
  typealias Entity = UpdateBloomingStateEntity

  let uploadUrl: String?
  let imageUrl: String?
}

extension UpdateBloomingStateDTO {
  func toEntity() throws -> Entity {
    return .init(
      message: "개화 상태가 기록되었습니다.",
      uploadUrl: uploadUrl,
      imageUrl: imageUrl
    )
  }
}

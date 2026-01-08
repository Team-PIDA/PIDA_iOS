//
//  UpdateBloomingStateDTO.swift
//  BloomingClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import APIClient

// TODO: 서버 응답 모델 변경 반영 필요
// - 현재 서버 응답: { uploadUrl: String, imageUrl: String }
// - 이미지 업로드 기능 추가 시 uploadUrl, imageUrl 활용 예정
struct UpdateBloomingStateDTO: DTO {
  typealias Entity = UpdateBloomingStateEntity

  let uploadUrl: String?
  let imageUrl: String?
}

extension UpdateBloomingStateDTO {
  func toEntity() throws -> Entity {
    // 현재는 서버 응답 무시하고 하드코딩된 메시지 반환
    return .init(message: "개화 상태가 기록되었습니다.")
  }
}

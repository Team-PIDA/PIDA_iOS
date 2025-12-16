//
//  AllFlowerSpotListModel.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 검색 결과 캐시 모델(임시)
/// - id: 검색 결과의 ID입니다.
/// - address: 상세 주소
/// - streetName: 거리 명
public struct AllFlowerSpotListModel: Codable {
  public let id: Int
  public let address: String?
  public let streetName: String?
  
  public init(
    id: Int,
    address: String?,
    streetName: String?
  ) {
    self.id = id
    self.address = address
    self.streetName = streetName
  }
}

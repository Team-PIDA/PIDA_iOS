//
//  SearchHistoryCacheModel.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 검색 기록 캐시 모델(임시)
/// - Searches: 검색 기록을 저장하는 문자열 배열입니다.
public struct RecentSearchItemModel: Codable {
  public let id: Int
  public let address: String?
  public let streetName: String?
  public let date: Date
  
  public init(
    id: Int,
    address: String?,
    streetName: String?,
    data: Date
  ) {
    self.id = id
    self.address = address
    self.streetName = streetName
    self.date = data
  }
}

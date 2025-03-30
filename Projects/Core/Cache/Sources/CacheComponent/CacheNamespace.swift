//
//  CacheNamespace.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 캐시 네임스페이스를 정의하는 프로토콜
public protocol CacheNamespace: RawRepresentable, Codable, Hashable where RawValue == String {}

/// 기본 캐시 네임스페이스 구현
/// - allFlowerSpotListModel: 도로명 및 주소 검색 결과
/// - searchHistory: 최근 검색 기록
public enum Search: String, CacheNamespace {
  case allFlowerSpotListModel = "AllFlowerSpotListModel"
  case searchHistory = "SearchHistory"
}

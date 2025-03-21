//
//  SearchResultCacheModel.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 검색 결과 캐시 모델
/// - id: 검색 결과의 ID입니다.
/// - title: 검색 결과의 제목입니다.
/// - description: 검색 결과의 설명입니다.
public struct SearchResultCacheModel: Codable {
  public let id: String
  public let title: String
  public let description: String
}

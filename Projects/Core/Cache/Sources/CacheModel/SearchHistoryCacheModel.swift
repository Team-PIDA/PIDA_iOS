//
//  SearchHistoryCacheModel.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 검색 기록 캐시 모델
/// - Searches: 검색 기록을 저장하는 문자열 배열입니다.
public struct SearchHistoryCacheModel: Codable {
  public var searches: [String]
}

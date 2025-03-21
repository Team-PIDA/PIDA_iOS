//
//  CacheError.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// Cache 모듈에서 발생할 수 있는 에러를 정의
public enum CacheError: Error, LocalizedError {
  case directoryCreationFailed
  case encodingFailed
  case decodingFailed
  case invalidKey
  case storageAccessFailed
  
  public var errorDescription: String? {
    switch self {
    case .directoryCreationFailed: return "캐시 디렉토리를 생성하는데 실패했습니다."
    case .encodingFailed: return "캐시 항목을 인코딩하는데 실패했습니다."
    case .decodingFailed: return "캐시 항목을 디코딩하는데 실패했습니다."
    case .invalidKey: return "유효하지 않은 캐시 키입니다."
    case .storageAccessFailed: return "캐시 저장소에 접근할 수 없습니다."
    }
  }
}

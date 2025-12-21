//
//  DownloadError.swift
//  Shared
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation

public enum DownloadError: Error, LocalizedError, Sendable, Equatable {
  case invalidStatusCode(Int)
  case emptyData
  case timeout(TimeInterval)
  case cancelled
  case unknown
  case customImageError(String)
  
  public var errorDescription: String {
    switch self {
    case let .invalidStatusCode(code):
      return "[잘못 된 StatusCode] - \(code)"
    case .emptyData:
      return "데이터가 존재하지 않습니다."
    case let .timeout(time):
      return "[네트워크 요청 시간이 초과되었습니다.] - \(time)Seconds"
    case .cancelled:
      return "다운로드 요청이 취소되었습니다."
    case .unknown:
      return "다운로드에 실패하였습니다."
    case let .customImageError(errorMsg):
      return "다운로드에 실패하였습니다 - \(errorMsg)"
    }
  }
}

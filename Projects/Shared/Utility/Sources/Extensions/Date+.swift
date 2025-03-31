//
//  Date+.swift
//  Utility
//
//  Created by Jiyeon on 3/31/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 변경하려는 포멧 스타일 정의
public enum DateFormatType {
  case mmdd
  
  public var format: String {
    switch self {
    case .mmdd:
      return "MM.dd"
    }
  }
}

public extension Date {
  static func formatter(with format: DateFormatType) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = format.format
    formatter.locale = Locale(identifier: "ko")
    return formatter
  }
  
  /// Date 타입을 String으로 변경
  func toString(format: DateFormatType) -> String {
    return Date.formatter(with: format).string(from: self)
  }
}

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
  case yearMonthDay
  
  public var format: String {
    switch self {
    case .mmdd:
      return "MM.dd"
    case .yearMonthDay:
      return "yyyy-MM-dd"
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
  
  /// 오늘, N일 전/후
  func relativeText(from referenceDate: Date = Date()) -> String {
    let calendar = Calendar.current
    let startOfSelf = calendar.startOfDay(for: self)
    let startOfReference = calendar.startOfDay(for: referenceDate)
    let components = calendar.dateComponents([.day], from: startOfReference, to: startOfSelf)
    let dayDiff = components.day ?? 0
    
    switch dayDiff {
    case 0: return "오늘"
    case let x where x < 0: return "\(-x)일 전"
    default: return "\(dayDiff)일 후"
    }
  }
}

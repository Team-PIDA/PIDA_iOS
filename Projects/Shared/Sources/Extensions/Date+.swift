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

  /// 사진 업로드 날짜 표기
  /// - 당일: nil
  /// - 1~10일 전: "N일 전"
  /// - 11일 이상 (같은 해): "M월 D일"
  /// - 11일 이상 (다른 해): "YYYY년 M월 D일"
  func photoDateText(from referenceDate: Date = Date()) -> String? {
    let calendar = Calendar.current
    let startOfSelf = calendar.startOfDay(for: self)
    let startOfReference = calendar.startOfDay(for: referenceDate)
    let components = calendar.dateComponents([.day], from: startOfSelf, to: startOfReference)
    let dayDiff = components.day ?? 0

    switch dayDiff {
    case 0:
      return nil
    case 1...10:
      return "\(dayDiff)일 전"
    default:
      let selfYear = calendar.component(.year, from: self)
      let referenceYear = calendar.component(.year, from: referenceDate)
      let month = calendar.component(.month, from: self)
      let day = calendar.component(.day, from: self)

      if selfYear == referenceYear {
        return "\(month)월 \(day)일"
      } else {
        return "\(selfYear)년 \(month)월 \(day)일"
      }
    }
  }
}

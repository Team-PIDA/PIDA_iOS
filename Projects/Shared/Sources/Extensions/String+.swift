//
//  String+.swift
//  Utility
//
//  Created by Jiyeon on 4/2/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public extension String {
  
  func toDate(format: DateFormatType) -> Date? {
    Date.formatter(with: format).date(from: self)
  }
  
  func relativeText(format: DateFormatType = .yearMonthDay) -> String {
    guard let date = self.toDate(format: format) else {
      return ""
    }
    return date.relativeText()
    }
}

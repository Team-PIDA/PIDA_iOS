//
//  Font+.swift
//  DesignKit
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import SwiftUI

extension DesignKitFontFamily {
  
  public struct FontSet {
    public struct Heading: Sendable {
      public static let heading1 = Font.custom("Pretendard-SemiBold", size: 24)
      public static let heading2 = Font.custom("Pretendard-SemiBold", size: 20)
      public static let heading3 = Font.custom("Pretendard-SemiBold", size: 18)
      public static let heading4 = Font.custom("Pretendard-SemiBold", size: 16)
    }
    
    public struct Title: Sendable {
      public static let title1 = Font.custom("Pretendard-SemiBold", size: 20)
      public static let title2 = Font.custom("Pretendard-SemiBold", size: 18)
      public static let title3 = Font.custom("Pretendard-SemiBold", size: 16)
      public static let title4 = Font.custom("Pretendard-SemiBold", size: 14)
      public static let title5 = Font.custom("Pretendard-SemiBold", size: 12)
    }
    
    public struct Body: Sendable {
      public static let body1 = Font.custom("Pretendard-SemiBold", size: 18)
      public static let body2 = Font.custom("Pretendard-SemiBold", size: 16)
      public static let body3 = Font.custom("Pretendard-SemiBold", size: 14)
    }
    
    public struct Caption: Sendable {
      public static let caption1 = Font.custom("Pretendard-SemiBold", size: 12)
      public static let caption2 = Font.custom("Pretendard-SemiBold", size: 8)
    }
    
    public struct Label: Sendable {
      public static let label1 = Font.custom("Pretendard-SemiBold", size: 16)
      public static let label2 = Font.custom("Pretendard-SemiBold", size: 14)
      public static let label3 = Font.custom("Pretendard-SemiBold", size: 12)
    }
  }
}

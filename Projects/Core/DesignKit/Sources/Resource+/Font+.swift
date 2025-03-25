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
  public struct FontSet: Sendable {
    public struct Heading: Sendable {
      public static let heading1 =  DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 24)
      public static let heading2 =  DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 20)
      public static let heading3 =  DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 18)
      public static let heading4 =  DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 16)
    }
    
    public struct Title: Sendable {
      public static let title1 = DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 20)
      public static let title2 = DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 18)
      public static let title3 = DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 16)
      public static let title4 = DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 14)
      public static let title5 = DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 12)
    }
    
    public struct Body: Sendable {
      public static let body1 = DesignKitFontFamily.Pretendard.regular.swiftUIFont(size: 18)
      public static let body2 = DesignKitFontFamily.Pretendard.regular.swiftUIFont(size: 16)
      public static let body3 = DesignKitFontFamily.Pretendard.medium.swiftUIFont(size: 14)
    }
    
    public struct Caption: Sendable {
      public static let caption1 = DesignKitFontFamily.Pretendard.medium.swiftUIFont(size: 12)
      public static let caption2 = DesignKitFontFamily.Pretendard.medium.swiftUIFont(size: 8)
    }
    
    public struct Label: Sendable {
      public static let label1 = DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 16)
      public static let label2 = DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 14)
      public static let label3 = DesignKitFontFamily.Pretendard.semiBold.swiftUIFont(size: 12)
    }
  }
}


extension DesignKitFontFamily {
  public struct FontStyle: Sendable {
    public struct Heading: Sendable {
      public static let heading1 = FontInfo(font: Pretendard.semiBold, size: 24, lineHeight: 1.4)
      public static let heading2 = FontInfo(font: Pretendard.semiBold, size: 20, lineHeight: 1.4)
      public static let heading3 = FontInfo(font: Pretendard.semiBold, size: 18, lineHeight: 1.4)
      public static let heading4 = FontInfo(font: Pretendard.semiBold, size: 16, lineHeight: 1.4)
    }
    
    public struct Title: Sendable {
      public static let title1 = FontInfo(font: Pretendard.semiBold, size: 20, lineHeight: 1.5)
      public static let title2 = FontInfo(font: Pretendard.semiBold, size: 18, lineHeight: 1.5)
      public static let title3 = FontInfo(font: Pretendard.semiBold, size: 16, lineHeight: 1.5)
      public static let title4 = FontInfo(font: Pretendard.semiBold, size: 14, lineHeight: 1.5)
      public static let title5 = FontInfo(font: Pretendard.semiBold, size: 12, lineHeight: 1.5)
    }
    
    public struct Body: Sendable {
      public static let body1 = FontInfo(font: Pretendard.regular, size: 18, lineHeight: 1.5)
      public static let body2 = FontInfo(font: Pretendard.regular, size: 16, lineHeight: 1.5)
      public static let body3 = FontInfo(font: Pretendard.medium, size: 14, lineHeight: 1.5)
    }
    
    public struct Caption: Sendable {
      public static let caption1 = FontInfo(font: Pretendard.medium, size: 12, lineHeight: 1.5)
      public static let caption2 = FontInfo(font: Pretendard.medium, size: 8, lineHeight: 1.6)
    }
    
    public struct Label: Sendable {
      public static let label1 = FontInfo(font: Pretendard.semiBold, size: 16, lineHeight: 1.5)
      public static let label2 = FontInfo(font: Pretendard.semiBold, size: 14, lineHeight: 1.5)
      public static let label3 = FontInfo(font: Pretendard.semiBold, size: 12, lineHeight: 1.5)
    }
  }
}

public struct FontInfo: Sendable {
  public let font: Font
  public let size: CGFloat
  public var lineSpacing: CGFloat
  
  public init(font: DesignKitFontConvertible, size: CGFloat, lineHeight: CGFloat) {
    self.font = font.swiftUIFont(size: size)
    self.lineSpacing = (size * lineHeight - size) / 2
    self.size = size
  }
}

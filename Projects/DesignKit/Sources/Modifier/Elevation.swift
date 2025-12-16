//
//  Elevation.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct ElevationModifier: ViewModifier {
  // 그림자 강도 수준을 정의합니다
  
  public enum Level {
    case small
    case medium
    case large
    
    public var radius: CGFloat {
      switch self {
      case .small: return 2
      case .medium: return 4
      case .large: return 8
      }
    }
    
    public var opacity: CGFloat {
      switch self {
      case .small: return 0.2
      case .medium: return 0.25
      case .large: return 0.3
      }
    }
  }
  
  public let backgroundColor: Color
  public let shadowLevel: Level
  public let cornerRadius: CGFloat
  
  public init(
    backgroundColor: Color,
    shadowLevel: Level,
    cornerRadius: CGFloat
  ) {
    self.backgroundColor = backgroundColor
    self.shadowLevel = shadowLevel
    self.cornerRadius = cornerRadius
  }
  
  public func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { geometry in
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(
              color: .black.opacity(shadowLevel.opacity),
              radius: shadowLevel.radius,
              x: .Number0,
              y: .Number0
            )
        }
      )
  }
}

public extension View {
  /// 뷰에 Elevation 효과를 적용합니다.
  /// 이 효과는 배경색, 코너 반경, 그림자를 포함합니다.
  ///
  /// - Parameters:
  ///   - cornerRadius: 적용할 코너 반경입니다. 기본값은 Constants.Number10입니다.
  ///   - backgroundColor: 배경색입니다. 기본값은 Constants.ColorGray0입니다.
  ///   - level: 그림자의 강도 레벨입니다. small, medium, large 중 선택할 수 있습니다. 기본값은 small입니다.
  /// - Returns: Elevation 효과가 적용된 수정된 뷰를 반환합니다.
  func elevation(
    backgroundColor: Color = ColorSet.Gray._0,
    level: ElevationModifier.Level = .small,
    cornerRadius: CGFloat
  ) -> some View {
    self.modifier(
      ElevationModifier(
        backgroundColor: backgroundColor,
        shadowLevel: level,
        cornerRadius: cornerRadius
      )
    )
  }
}

//
//  BloomStatus.swift
//  Utility
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import SwiftUI

public enum BloomStatus: String, Sendable {
  case little = "LITTLE"
  case bloomed = "BLOOMED"
  case withered = "WITHERED"
  case notBloomed = "NOT_BLOOMED"
}

public extension BloomStatus {
  var text: String {
    switch self {
    case .little:
      "아직이에요"
    case .bloomed:
      "만개예요!"
    case .withered:
      "저물었어요.."
    case .notBloomed:
      "안폈어요"
    }
  }
  
  var pinImage: Image? {
    switch self {
    case .little:
      Image(asset: ImageSet.fewLargePin.swiftUIImage)
    case .bloomed:
      Image(asset: ImageSet.manyLargePin.swiftUIImage)
    case .withered:
      Image(asset: ImageSet.goneLargePin.swiftUIImage)
    default:
      nil
    }
  }
  
  var gradiant: LinearGradient {
    switch self {
    case .little:
      ColorSet.GradiantSet.gra3
    case .bloomed:
      ColorSet.GradiantSet.gra1
    case .withered:
      ColorSet.GradiantSet.gra2
    default:
      ColorSet.GradiantSet.gra4
    }
  }
  
  var textColor: Color {
    switch self {
    case .little:
      ColorSet.Text.Accent
    case .bloomed:
      ColorSet.Pink._400
    case .withered:
      ColorSet.Orange._400
    default:
      ColorSet.Text.Secondary
    }
  }
  
  var activeColor: Color {
    switch self {
    case .little:
      ColorSet.Mint._300
    case .bloomed:
      ColorSet.Pink._300
    case .withered:
      ColorSet.Orange._300
    case .notBloomed:
      ColorSet.Gray._400
    }
  }
  
  var inactiveColor: Color {
    switch self {
    case .little:
      ColorSet.Mint._50
    case .bloomed:
      ColorSet.Pink._50
    case .withered:
      ColorSet.Orange._50
    default:
      ColorSet.Background.Tertiary
    }
  }
  
}

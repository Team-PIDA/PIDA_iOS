//
//  Color+.swift
//  DesignKit
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import SwiftUI

extension DesignKitAsset {
  
  public struct ColorSet: Sendable {
    
    public struct Gray: Sendable {
      public static let _0 = DesignKitAsset.Colors.gray0.swiftUIColor
      public static let _50 = DesignKitAsset.Colors.gray50.swiftUIColor
      public static let _100 = DesignKitAsset.Colors.gray100.swiftUIColor
      public static let _200 = DesignKitAsset.Colors.gray200.swiftUIColor
      public static let _300 = DesignKitAsset.Colors.gray300.swiftUIColor
      public static let _400 = DesignKitAsset.Colors.gray400.swiftUIColor
      public static let _500 = DesignKitAsset.Colors.gray500.swiftUIColor
      public static let _600 = DesignKitAsset.Colors.gray600.swiftUIColor
      public static let _700 = DesignKitAsset.Colors.gray700.swiftUIColor
      public static let _800 = DesignKitAsset.Colors.gray800.swiftUIColor
      public static let _900 = DesignKitAsset.Colors.gray900.swiftUIColor
      public static let _1000 = DesignKitAsset.Colors.gray1000.swiftUIColor
    }
    
    public struct Mint: Sendable {
      public static let _50 = DesignKitAsset.Colors.mint50.swiftUIColor
      public static let _75 = DesignKitAsset.Colors.mint75.swiftUIColor
      public static let _100 = DesignKitAsset.Colors.mint100.swiftUIColor
      public static let _200 = DesignKitAsset.Colors.mint200.swiftUIColor
      public static let _300 = DesignKitAsset.Colors.mint300.swiftUIColor
      public static let _400 = DesignKitAsset.Colors.mint400.swiftUIColor
      public static let _500 = DesignKitAsset.Colors.mint500.swiftUIColor
    }
    
    public struct Pink: Sendable {
      public static let _50 = DesignKitAsset.Colors.pink50.swiftUIColor
      public static let _75 = DesignKitAsset.Colors.pink75.swiftUIColor
      public static let _100 = DesignKitAsset.Colors.pink100.swiftUIColor
      public static let _200 = DesignKitAsset.Colors.pink200.swiftUIColor
      public static let _300 = DesignKitAsset.Colors.pink300.swiftUIColor
      public static let _400 = DesignKitAsset.Colors.pink400.swiftUIColor
      public static let _500 = DesignKitAsset.Colors.pink500.swiftUIColor
    }
    
    public struct SubColor: Sendable {
      public static let red = DesignKitAsset.Colors.red.swiftUIColor
    }
    
    public struct Orange: Sendable {
      public static let _0 = DesignKitAsset.Colors.orange0.swiftUIColor
      public static let _50 = DesignKitAsset.Colors.orange50.swiftUIColor
      public static let _100 = DesignKitAsset.Colors.orange100.swiftUIColor
      public static let _200 = DesignKitAsset.Colors.orange200.swiftUIColor
      public static let _300 = DesignKitAsset.Colors.orange300.swiftUIColor
      public static let _400 = DesignKitAsset.Colors.orange400.swiftUIColor
      public static let _500 = DesignKitAsset.Colors.orange500.swiftUIColor
    }
    
    public struct Border: Sendable {
      public static let Strong = ColorSet.Gray._500
      public static let Primary = ColorSet.Gray._200
      public static let Secondary = ColorSet.Gray._100
      public static let Error = ColorSet.SubColor.red
      public static let Accent = ColorSet.Mint._300
    }
    
    public struct Icon: Sendable {
      public static let Primary = ColorSet.Gray._500
      public static let Secondary = ColorSet.Gray._400
      public static let Tertiary = ColorSet.Gray._300
      public static let Accent = ColorSet.Mint._400
      public static let Inverse = ColorSet.Gray._0
    }
    
    public struct Text: Sendable {
      public static let Primary = ColorSet.Gray._800
      public static let Secondary = ColorSet.Gray._400
      public static let Tertiary = ColorSet.Gray._300
      public static let Disabled = ColorSet.Gray._300
      public static let Accent = ColorSet.Mint._400
      public static let Error = ColorSet.SubColor.red
      public static let Inverse = ColorSet.Gray._0
    }
    
    public struct Background: Sendable {
      public static let Primary = ColorSet.Gray._0
      public static let Secondary = ColorSet.Gray._50
      public static let Tertiary = ColorSet.Gray._100
      public static let Inverse = ColorSet.Gray._700
      public static let Accent = ColorSet.Mint._50
    }
    
    public struct Component: Sendable {
      public static let Primary = ColorSet.Mint._300
      public static let Disabled = ColorSet.Gray._50
      public static let Pressed = ColorSet.Gray._1000.opacity(0.12)
      public static let Error = ColorSet.SubColor.red
    }
    
    public struct GradiantSet: Sendable {
      public static let gra1 = LinearGradient(
        gradient: Gradient(stops: [
          .init(color: ColorSet.Pink._300, location: 0.0),
          .init(color: ColorSet.Orange._50, location: 1.82)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      public static let gra2 = LinearGradient(
        gradient: Gradient(stops: [
          .init(color: ColorSet.Orange._300, location: 0.0),
          .init(color: ColorSet.Orange._50, location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      public static let gra3 = LinearGradient(
        gradient: Gradient(stops: [
          .init(color: ColorSet.Mint._300, location: 0.0),
          .init(color: ColorSet.Orange._0, location: 1.65)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      public static let gra4 = LinearGradient(
        gradient: Gradient(stops: [
          .init(color: ColorSet.Gray._400, location: 0.0),
          .init(color: ColorSet.Gray._200, location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
    }
  }
}

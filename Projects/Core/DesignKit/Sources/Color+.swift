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
      public static let _0 = DesignKitAsset.gray0
      public static let _50 = DesignKitAsset.gray50
      public static let _100 = DesignKitAsset.gray100
      public static let _200 = DesignKitAsset.gray200
      public static let _300 = DesignKitAsset.gray300
      public static let _400 = DesignKitAsset.gray400
      public static let _500 = DesignKitAsset.gray500
      public static let _600 = DesignKitAsset.gray600
      public static let _700 = DesignKitAsset.gray700
      public static let _800 = DesignKitAsset.gray800
      public static let _900 = DesignKitAsset.gray900
      public static let _1000 = DesignKitAsset.gray1000
    }
    
    public struct Mint: Sendable {
      public static let _50 = DesignKitAsset.mint50
      public static let _75 = DesignKitAsset.mint75
      public static let _100 = DesignKitAsset.mint100
      public static let _200 = DesignKitAsset.mint200
      public static let _300 = DesignKitAsset.mint300
      public static let _400 = DesignKitAsset.mint400
      public static let _500 = DesignKitAsset.mint500
    }
    
    public struct Pink: Sendable {
      public static let _50 = DesignKitAsset.pink50
      public static let _75 = DesignKitAsset.pink75
      public static let _100 = DesignKitAsset.pink100
      public static let _200 = DesignKitAsset.pink200
      public static let _300 = DesignKitAsset.pink300
      public static let _400 = DesignKitAsset.pink400
      public static let _500 = DesignKitAsset.pink500
    }
    
    public struct SubColor: Sendable {
      public static let red = DesignKitAsset.red
    }
    
    public struct Orange: Sendable {
      public static let _0 = DesignKitAsset.orange0
      public static let _50 = DesignKitAsset.orange50
      public static let _100 = DesignKitAsset.orange100
      public static let _200 = DesignKitAsset.orange200
      public static let _300 = DesignKitAsset.orange300
      public static let _400 = DesignKitAsset.orange400
      public static let _500 = DesignKitAsset.orange500
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
    
    public struct Button: Sendable {
      public static let Primary = ColorSet.Mint._300
      public static let Disabled = ColorSet.Gray._50
      public static let Pressed = ColorSet.Gray._1000.swiftUIColor.opacity(0.12)
      public static let Error = ColorSet.SubColor.red
    }
    
    public struct Gra: Sendable {
      public static let gra1 = LinearGradient(
        gradient: Gradient(stops: [
          .init(color: ColorSet.Pink._300.swiftUIColor, location: 0.0),
          .init(color: ColorSet.Orange._50.swiftUIColor, location: 1.82)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      public static let gra2 = LinearGradient(
        gradient: Gradient(stops: [
          .init(color: ColorSet.Orange._300.swiftUIColor, location: 0.0),
          .init(color: ColorSet.Orange._50.swiftUIColor, location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      public static let gra3 = LinearGradient(
        gradient: Gradient(stops: [
          .init(color: ColorSet.Mint._300.swiftUIColor, location: 0.0),
          .init(color: ColorSet.Orange._0.swiftUIColor, location: 1.65)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      public static let gra4 = LinearGradient(
        gradient: Gradient(stops: [
          .init(color: ColorSet.Gray._400.swiftUIColor, location: 0.0),
          .init(color: ColorSet.Gray._200.swiftUIColor, location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
    }
  }
}

//
//  BlossomState+.swift
//  DesignKit
//
//  Created by Jiyeon on 4/2/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit

public extension BloomStatus {
  private typealias Images = DesignKitAsset.Icons
  
  private static let activeImages: [Self: UIImage] = [
    .withered: Images.goneActive.image,
    .bloomed: Images.manyActive.image,
    .little: Images.fewActive.image,
    .notBloomed: Images.noneActive.image
  ]
  private static let inactiveImages: [Self: UIImage] = [
    .withered: Images.goneInactive.image,
    .bloomed: Images.manyInactive.image,
    .little: Images.fewInactive.image,
    .notBloomed: Images.noneInactive.image
  ]
  private static let pathPointImages: [Self: UIImage] = [
    .withered: Images.gonePathpoint.image,
    .bloomed: Images.manyPathpoint.image,
    .little: Images.fewPathpoint.image,
    .notBloomed: Images.nonePathpoint.image
  ]
  
  var activeImage: UIImage { Self.activeImages[self]! }
  
  var inactiveImage: UIImage { Self.inactiveImages[self]! }
  
  var color: UIColor {
    switch self {
    case .withered:
      UIColor(ColorSet.Orange._300)
    case .bloomed:
      UIColor(ColorSet.Pink._300)
    case .little:
      UIColor(ColorSet.Mint._300)
    case .notBloomed:
      UIColor(ColorSet.Gray._400)
    }
  }
  
  var circleImage: UIImage { Self.pathPointImages[self]! }
}


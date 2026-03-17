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
  
  var activeImage: UIImage {
    switch self {
    case .little:
      Images.fewActive.image
    case .bloomed:
      Images.manyActive.image
    case .withered:
      Images.goneActive.image
    case .notBloomed:
      Images.noneActive.image
    }
  }
  
  var inactiveImage: UIImage {
    switch self {
    case .little:
      Images.fewInactive.image
    case .bloomed:
      Images.manyInactive.image
    case .withered:
      Images.goneInactive.image
    case .notBloomed:
      Images.noneInactive.image
    }
  }
  
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
  
  var circleImage: UIImage {
    switch self {
    case .little:
      Images.fewPathpoint.image
    case .bloomed:
      Images.manyPathpoint.image
    case .withered:
      Images.gonePathpoint.image
    case .notBloomed:
      Images.nonePathpoint.image
    }
  }
}


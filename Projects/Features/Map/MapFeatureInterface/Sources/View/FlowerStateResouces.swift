//
//  FlowerStateImage.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import UIKit
import DesignKit
import MapDomainInterface

extension FlowerState {
  private typealias Images = DesignKitAsset.Icons
  private typealias Colors = DesignKitAsset.ColorSet
  
  var activeImage: UIImage {
    switch self {
    case .gone:
      return Images.goneActive.image
    case .many:
      return Images.manyActive.image
    case .few:
      return Images.fewActive.image
    case .none:
      return Images.noneActive.image
    }
  }
  var inactiveImage: UIImage {
    switch self {
    case .gone:
      return Images.goneInactive.image
    case .many:
      return Images.manyInactive.image
    case .few:
      return Images.fewInactive.image
    case .none:
      return Images.noneInactive.image
    }
  }
  var color: UIColor {
    switch self {
    case .gone:
      UIColor(Colors.Orange._300)
    case .many:
      UIColor(Colors.Pink._300)
    case .few:
      UIColor(Colors.Mint._300)
    case .none:
      UIColor(Colors.Gray._400)
    }
  }
}


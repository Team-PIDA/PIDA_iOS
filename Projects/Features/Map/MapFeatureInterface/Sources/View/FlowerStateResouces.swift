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
import NMapsMap

extension FlowerState {
  private typealias Images = DesignKitAsset.Icons
  private typealias Colors = DesignKitAsset.ColorSet
  
  private static let activeImages: [FlowerState: NMFOverlayImage] = [
    .gone: NMFOverlayImage(image: Images.goneActive.image),
    .many: NMFOverlayImage(image: Images.manyActive.image),
    .few: NMFOverlayImage(image: Images.fewActive.image),
    .none: NMFOverlayImage(image: Images.noneActive.image)
  ]
  private static let inactiveImages: [FlowerState: NMFOverlayImage] = [
    .gone: NMFOverlayImage(image: Images.goneInactive.image),
    .many: NMFOverlayImage(image: Images.manyInactive.image),
    .few: NMFOverlayImage(image: Images.fewInactive.image),
    .none: NMFOverlayImage(image: Images.noneInactive.image)
  ]
  
  var activeImage: NMFOverlayImage {
    Self.activeImages[self]!
  }
  
  var inactiveImage: NMFOverlayImage {
    Self.inactiveImages[self]!
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


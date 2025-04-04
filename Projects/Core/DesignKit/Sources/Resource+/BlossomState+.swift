//
//  BlossomState+.swift
//  DesignKit
//
//  Created by Jiyeon on 4/2/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import NMapsMap

public extension BloomStatus {
  private typealias Images = DesignKitAsset.Icons
  
  private static let activeImages: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Images.goneActive.image),
    .bloomed: NMFOverlayImage(image: Images.manyActive.image),
    .little: NMFOverlayImage(image: Images.fewActive.image),
    .notBloomed: NMFOverlayImage(image: Images.noneActive.image)
  ]
  private static let inactiveImages: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Images.goneInactive.image),
    .bloomed: NMFOverlayImage(image: Images.manyInactive.image),
    .little: NMFOverlayImage(image: Images.fewInactive.image),
    .notBloomed: NMFOverlayImage(image: Images.noneInactive.image)
  ]
  private static let pathPointImages: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Images.gonePathpoint.image),
    .bloomed: NMFOverlayImage(image: Images.manyPathpoint.image),
    .little: NMFOverlayImage(image: Images.fewPathpoint.image),
    .notBloomed: NMFOverlayImage(image: Images.nonePathpoint.image)
  ]
  
  var activeImage: NMFOverlayImage {
    Self.activeImages[self]!
  }
  
  var inactiveImage: NMFOverlayImage {
    Self.inactiveImages[self]!
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
  
  var circleImage: NMFOverlayImage {
    Self.pathPointImages[self]!
  }
}


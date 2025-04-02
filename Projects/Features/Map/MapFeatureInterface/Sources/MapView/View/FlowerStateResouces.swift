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
import FlowerSpotDomainInterface
import NMapsMap
import Utility

extension BloomStatus {
  private typealias Images = DesignKitAsset.Icons
  
  private static let activeImages: [BloomStatus: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Images.goneActive.image),
    .bloomed: NMFOverlayImage(image: Images.manyActive.image),
    .little: NMFOverlayImage(image: Images.fewActive.image),
    .notBloomed: NMFOverlayImage(image: Images.noneActive.image)
  ]
  private static let inactiveImages: [BloomStatus: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Images.goneInactive.image),
    .bloomed: NMFOverlayImage(image: Images.manyInactive.image),
    .little: NMFOverlayImage(image: Images.fewInactive.image),
    .notBloomed: NMFOverlayImage(image: Images.noneInactive.image)
  ]
  private static let pathPointImages: [BloomStatus: NMFOverlayImage] = [
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
    UIColor(activeColor)
  }
  
  var circleImage: NMFOverlayImage {
    Self.pathPointImages[self]!
  }
}


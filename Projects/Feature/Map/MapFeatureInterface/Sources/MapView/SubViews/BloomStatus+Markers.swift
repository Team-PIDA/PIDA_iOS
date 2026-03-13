//
//  BloomStatus+Markers.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/13/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import NMapsMap
import DesignKit

extension BloomStatus {  
  private static let activeMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.activeImage),
    .bloomed: NMFOverlayImage(image: Self.bloomed.activeImage),
    .little: NMFOverlayImage(image: Self.little.activeImage),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.activeImage)
  ]
  private static let inactiveMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.inactiveImage),
    .bloomed: NMFOverlayImage(image: Self.bloomed.inactiveImage),
    .little: NMFOverlayImage(image: Self.little.inactiveImage),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.inactiveImage)
  ]
  private static let pathPointMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.circleImage),
    .bloomed: NMFOverlayImage(image: Self.bloomed.circleImage),
    .little: NMFOverlayImage(image: Self.little.circleImage),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.circleImage)
  ]
  
  var activeMarker: NMFOverlayImage {
    Self.activeMarkers[self] ?? NMFOverlayImage(image: self.activeImage)
  }
  
  var inactiveMarker: NMFOverlayImage {
    Self.inactiveMarkers[self] ?? NMFOverlayImage(image: self.inactiveImage)
  }
  
  var pathPointMarker: NMFOverlayImage {
    Self.pathPointMarkers[self] ?? NMFOverlayImage(image: self.circleImage)
  }
}

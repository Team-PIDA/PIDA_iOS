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

@MainActor
extension BloomStatus {
  private static let activeFlowerMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.activePinImage(spotType: .flower)),
    .bloomed: NMFOverlayImage(image: Self.bloomed.activePinImage(spotType: .flower)),
    .little: NMFOverlayImage(image: Self.little.activePinImage(spotType: .flower)),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.activePinImage(spotType: .flower))
  ]
  private static let inactiveFlowerMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.inactivePinImage(spotType: .flower)),
    .bloomed: NMFOverlayImage(image: Self.bloomed.inactivePinImage(spotType: .flower)),
    .little: NMFOverlayImage(image: Self.little.inactivePinImage(spotType: .flower)),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.inactivePinImage(spotType: .flower))
  ]

  private static let activeCafeMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.activePinImage(spotType: .cafe)),
    .bloomed: NMFOverlayImage(image: Self.bloomed.activePinImage(spotType: .cafe)),
    .little: NMFOverlayImage(image: Self.little.activePinImage(spotType: .cafe)),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.activePinImage(spotType: .cafe))
  ]
  private static let inactiveCafeMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.inactivePinImage(spotType: .cafe)),
    .bloomed: NMFOverlayImage(image: Self.bloomed.inactivePinImage(spotType: .cafe)),
    .little: NMFOverlayImage(image: Self.little.inactivePinImage(spotType: .cafe)),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.inactivePinImage(spotType: .cafe))
  ]

  private static let activeFestivalMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.activePinImage(spotType: .festival)),
    .bloomed: NMFOverlayImage(image: Self.bloomed.activePinImage(spotType: .festival)),
    .little: NMFOverlayImage(image: Self.little.activePinImage(spotType: .festival)),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.activePinImage(spotType: .festival))
  ]
  private static let inactiveFestivalMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.inactivePinImage(spotType: .festival)),
    .bloomed: NMFOverlayImage(image: Self.bloomed.inactivePinImage(spotType: .festival)),
    .little: NMFOverlayImage(image: Self.little.inactivePinImage(spotType: .festival)),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.inactivePinImage(spotType: .festival))
  ]

  private static let activeStepMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.activePinImage(spotType: .step)),
    .bloomed: NMFOverlayImage(image: Self.bloomed.activePinImage(spotType: .step)),
    .little: NMFOverlayImage(image: Self.little.activePinImage(spotType: .step)),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.activePinImage(spotType: .step))
  ]
  private static let inactiveStepMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.inactivePinImage(spotType: .step)),
    .bloomed: NMFOverlayImage(image: Self.bloomed.inactivePinImage(spotType: .step)),
    .little: NMFOverlayImage(image: Self.little.inactivePinImage(spotType: .step)),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.inactivePinImage(spotType: .step))
  ]

  func activeMarker(type: MapSpotType) -> NMFOverlayImage {
    switch type {
    case .flower:
      Self.activeFlowerMarkers[self] ?? NMFOverlayImage(image: self.activePinImage(spotType: .flower))
    case .cafe:
      Self.activeCafeMarkers[self] ?? NMFOverlayImage(image: self.activePinImage(spotType: .cafe))
    case .step:
      Self.activeStepMarkers[self] ?? NMFOverlayImage(image: self.activePinImage(spotType: .step))
    case .festival:
      Self.activeFestivalMarkers[self] ?? NMFOverlayImage(image: self.activePinImage(spotType: .festival))
    }
  }
  
  func inactiveMarker(type: MapSpotType) -> NMFOverlayImage {
    switch type {
    case .flower:
      Self.inactiveFlowerMarkers[self] ?? NMFOverlayImage(image: self.inactivePinImage(spotType: .flower))
    case .cafe:
      Self.inactiveCafeMarkers[self] ?? NMFOverlayImage(image: self.inactivePinImage(spotType: .cafe))
    case .step:
      Self.inactiveStepMarkers[self] ?? NMFOverlayImage(image: self.inactivePinImage(spotType: .step))
    case .festival:
      Self.inactiveFestivalMarkers[self] ?? NMFOverlayImage(image: self.inactivePinImage(spotType: .festival))
    }
  }
  
  private static let pathPointMarkers: [Self: NMFOverlayImage] = [
    .withered: NMFOverlayImage(image: Self.withered.circleImage),
    .bloomed: NMFOverlayImage(image: Self.bloomed.circleImage),
    .little: NMFOverlayImage(image: Self.little.circleImage),
    .notBloomed: NMFOverlayImage(image: Self.notBloomed.circleImage)
  ]
  
  var pathPointMarker: NMFOverlayImage {
    Self.pathPointMarkers[self] ?? NMFOverlayImage(image: self.circleImage)
  }
}

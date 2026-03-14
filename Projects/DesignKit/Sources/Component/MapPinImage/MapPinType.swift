//
//  MapPinType.swift
//  DesignKit
//
//  Created by Jiyeon on 3/13/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public enum MapPinState: Equatable, Sendable {
  case inactive
  case active
}

public enum MapSpotType: Equatable, Sendable {
  case flower
  case cafe
  case steps
  case festival

  var icon: ImageSet {
    switch self {
    case .flower:
      return ImageSet.flower
    case .cafe:
      return ImageSet.cafeFilled
    case .steps:
      return ImageSet.stepsFilled
    case .festival:
      return ImageSet.eventFilled
    }
  }
}

//
//  Image+.swift
//  DesignKit
//
//  Created by 조용인 on 3/17/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public enum ImageSet {
  case back, chevronRight, close, copy, distance,
       flower, location, myLocation, placeholder,
       replay, search, sentimentDissatisfied, warning
  
  public var swiftUIImage: Image {
    switch self {
    case .back: return DesignKitAsset.Icons.back.swiftUIImage
    case .chevronRight: return DesignKitAsset.Icons.chevronRight.swiftUIImage
    case .close: return DesignKitAsset.Icons.close.swiftUIImage
    case .copy: return DesignKitAsset.Icons.copy.swiftUIImage
    case .distance: return DesignKitAsset.Icons.distance.swiftUIImage
    case .flower: return DesignKitAsset.Icons.flower.swiftUIImage
    case .location: return DesignKitAsset.Icons.location.swiftUIImage
    case .myLocation: return DesignKitAsset.Icons.myLocation.swiftUIImage
    case .placeholder: return DesignKitAsset.Icons.placeholder.swiftUIImage
    case .replay: return DesignKitAsset.Icons.replay.swiftUIImage
    case .search: return DesignKitAsset.Icons.search.swiftUIImage
    case .sentimentDissatisfied: return DesignKitAsset.Icons.sentimentDissatisfied.swiftUIImage
    case .warning: return DesignKitAsset.Icons.warning.swiftUIImage
    }
  }
}

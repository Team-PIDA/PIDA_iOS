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
       replay, search, sentimentDissatisfied, warning, avatar, avatarLarge
  
  public var swiftUIImage: DesignKitImages {
    switch self {
    case .back: return DesignKitAsset.Icons.back
    case .chevronRight: return DesignKitAsset.Icons.chevronRight
    case .close: return DesignKitAsset.Icons.close
    case .copy: return DesignKitAsset.Icons.copy
    case .distance: return DesignKitAsset.Icons.distance
    case .flower: return DesignKitAsset.Icons.flower
    case .location: return DesignKitAsset.Icons.location
    case .myLocation: return DesignKitAsset.Icons.myLocation
    case .placeholder: return DesignKitAsset.Icons.placeholder
    case .replay: return DesignKitAsset.Icons.replay
    case .search: return DesignKitAsset.Icons.search
    case .sentimentDissatisfied: return DesignKitAsset.Icons.sentimentDissatisfied
    case .warning: return DesignKitAsset.Icons.warning
    case .avatar: return DesignKitAsset.Icons.avatarSmall
    case .avatarLarge: return DesignKitAsset.Icons.avatarBig
    }
  }
}

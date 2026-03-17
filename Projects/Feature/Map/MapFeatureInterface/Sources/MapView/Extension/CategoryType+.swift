//
//  CategoryType+.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/14/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI
import DesignKit
import CategoryClient

extension CategoryType {
  var icon: ImageSet? {
    switch self {
    case .event: return ImageSet.event
    case .trail: return ImageSet.steps
    case .cafe: return ImageSet.cafe
    default: return nil
    }
  }
}

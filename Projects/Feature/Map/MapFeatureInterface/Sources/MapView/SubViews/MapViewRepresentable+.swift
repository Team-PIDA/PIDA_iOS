//
//  MapViewRepresentable+.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Shared

extension MapViewRepresentable {
  
  /// 현재 지도 범위를 가져오는 메서드
  func onReceiveMapBounds(
    _ action: @escaping (_ southWest: Coordinate, _ northEast: Coordinate) -> Void
  ) -> Self {
    var map = self
    map.mapBounds = action
    return map
  }
  func onMarkerTapped(_ action: @escaping (Int?) -> Void) -> Self {
    var map = self
    map.onMarkerTapped = action
    return map
  }
  func cameraMoveEvent(_ action: @escaping () -> Void) -> Self {
    var map = self
    map.cameraMoveEvent = action
    return map
  }
}

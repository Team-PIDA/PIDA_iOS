//
//  LocationReducer.swift
//  MapFeature
//
//  Created by Jiyeon on 4/7/25.
//  Copyright © 2025 com.pida.me.ios. All rights reserved.
//

import Foundation
import FlowerSpotDomainInterface
import DesignKit

extension MapReducer {
  
  public struct LocationState: Equatable {
    public var isCurrentButtonTap: Bool = false
  }
  
  public enum LocationAction: Equatable {
    case fetchUserLocation
    case moveUserLocation
    case saveUserLocation(MapPoint)
    case moveLocation(MapPoint)
    case requestMapBounds(Bool)
    case currentButtonTapped(Bool)
    
    case fetchFlowers([MapPoint])
    case storeFlowerData([FlowerSpot])
    
    case mapSearchError(String?)
    case showToastView(message: String?)
    case presentAlert(type: AlertType)
  }
  
}

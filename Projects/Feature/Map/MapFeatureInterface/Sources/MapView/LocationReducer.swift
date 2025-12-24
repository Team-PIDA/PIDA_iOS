//
//  LocationReducer.swift
//  MapFeature
//
//  Created by Jiyeon on 4/7/25.
//  Copyright © 2025 com.pida.me.ios. All rights reserved.
//

import Foundation
import DesignKit
import FlowerSpotClient

extension MapReducer {
  
  public struct LocationState: Equatable {
    public var isCurrentButtonTap: Bool = false
  }
  
  public enum LocationAction: Equatable {
    case fetchUserLocation
    case moveUserLocation
    case saveUserLocation(MapPointEntity)
    case moveLocation(MapPointEntity)
    case requestMapBounds(Bool)
    case currentButtonTapped(Bool)
    
    case fetchFlowers([MapPointEntity])
    case storeFlowerData([FlowerSpotEntity])
    
    case mapSearchError(String?)
    case showToastView(message: String?, buttonLabel: String?)
    case presentAlert(type: AlertType)
  }
  
}

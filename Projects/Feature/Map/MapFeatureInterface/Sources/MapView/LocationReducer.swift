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
import Shared

extension MapReducer {
  
  public struct LocationState: Equatable {
    public var isCurrentButtonTap: Bool = false
  }
  
  public enum LocationAction: Equatable {
    case moveUserLocation
    case saveUserLocation(Coordinate)
    case moveLocation(Coordinate)
    case requestMapBounds(Bool)
    case currentButtonTapped(Bool)
    
    case fetchFlowers([Coordinate])
    case storeFlowerData([FlowerSpotEntity])
    
    case mapSearchError(String?)
    case showToastView(message: String?, buttonLabel: String?)
    case presentAlert(type: AlertType)
  }
  
}

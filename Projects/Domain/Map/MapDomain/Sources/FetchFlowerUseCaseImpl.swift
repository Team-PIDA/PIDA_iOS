//
//  MapUseCaseImpl.swift
//
//  Map
//
//  Created by JiYeon
//

import Foundation
import MapDomainInterface

public struct FetchFlowerUseCaseImpl: FetchFlowerUseCase {
  
  public init() {
    
  }
  
  public func execute(southWest: MapPoint, northEast: MapPoint) async throws -> [FlowerPosition] {
    print(southWest)
    print(northEast)
    return []

  }
}

//
//  MapUsecCase.swift
//
//  Map
//
//  Created by JiYeon
//

import Foundation

public protocol FetchFlowerUseCase {
  func execute(southWest: MapPoint, northEast: MapPoint) async throws -> [FlowerPosition]
}


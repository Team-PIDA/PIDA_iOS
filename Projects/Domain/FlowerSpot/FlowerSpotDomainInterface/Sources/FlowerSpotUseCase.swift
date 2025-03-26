//
//  FlowerSpotUsecCase.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation

public protocol FetchAllFlowerPinUseCase {
  func execute() async throws -> Void
}

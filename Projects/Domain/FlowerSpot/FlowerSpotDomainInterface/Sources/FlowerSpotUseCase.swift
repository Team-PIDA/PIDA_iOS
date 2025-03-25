//
//  FlowerSpotUsecCase.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation

public protocol FlowerSpotUseCase {
  func execute() async throws -> Void
}

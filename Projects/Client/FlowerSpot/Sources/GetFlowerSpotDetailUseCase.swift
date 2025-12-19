//
//  GetFlowerSpotDetailUseCase.swift
//  FlowerSpotDomainInterface
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol GetFlowerSpotDetailUseCase {
  func execute(id: Int) async throws -> FlowerSpot
}

//
//  VerifyBloomingTodayUseCase.swift
//  BloomingDomainInterface
//
//  Created by 조용인 on 4/4/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol VerifyBloomingTodayUseCase {
  func execute(id: Int) async throws -> VerifyBloomingStateEntity
}

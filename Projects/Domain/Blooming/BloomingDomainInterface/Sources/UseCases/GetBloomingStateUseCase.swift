//
//  GetBloomingStateUseCase.swift
//  BloomingDomainInterface
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol GetBloomingStateUseCase {
  func execute(id: Int) async throws -> BloomStatusEntity
}

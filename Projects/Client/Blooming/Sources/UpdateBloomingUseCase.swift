//
//  UpdateBloomingUseCase.swift
//  BloomingDomainInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol UpdateBloomingUseCase {
  func execute(id: Int, status: String) async throws
}

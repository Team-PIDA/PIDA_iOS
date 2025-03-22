//
//  AuthRepository.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 3/22/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol AuthRepository {
  func fetchData() async throws -> Void
}

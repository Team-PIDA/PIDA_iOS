//
//  SignUpUseCase.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol SignUpUseCase {
  func execute(email: String, nickname: String) async throws -> Void
}

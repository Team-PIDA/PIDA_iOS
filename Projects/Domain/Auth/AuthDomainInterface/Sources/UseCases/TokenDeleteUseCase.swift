//
//  TokenDeleteUseCase.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol TokenDeleteUseCase {
  func execute() async -> Void
}

//
//  WithdrawUseCase.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol WithdrawUseCase {
  func execute() async throws
}

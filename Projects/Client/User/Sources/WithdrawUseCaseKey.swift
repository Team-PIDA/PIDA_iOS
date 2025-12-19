//
//  WithdrawUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum WithdrawUseCaseKey: DependencyKey {
  public static var liveValue: WithdrawUseCase { withdrawUseCaseProvider() }
  public static var previewValue: WithdrawUseCase { withdrawUseCaseProvider() }
  public static var testValue: WithdrawUseCase { withdrawUseCaseProvider() }
}

var withdrawUseCaseProvider: () -> WithdrawUseCase = {
  fatalError("withdrawUseCaseProvider Dependency not configured")
}

public func withdrawUseCaseRegister(
  provider: @escaping () -> WithdrawUseCase
) {
  withdrawUseCaseProvider = provider
}

extension DependencyValues {
  public var withdrawUseCase: WithdrawUseCase {
    get { self[WithdrawUseCaseKey.self] }
    set { self[WithdrawUseCaseKey.self] = newValue }
  }
}

//
//  AppleLoginUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum AppleLoginUseCaseKey: DependencyKey {
  public static var liveValue: AppleLoginUseCase { appleLoginUseCaseProvider() }
  public static var previewValue: AppleLoginUseCase { appleLoginUseCaseProvider() }
  public static var testValue: AppleLoginUseCase { appleLoginUseCaseProvider() }
}

var appleLoginUseCaseProvider: () -> AppleLoginUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func appleLoginUseCaseRegister(
  provider: @escaping () -> AppleLoginUseCase
) {
  appleLoginUseCaseProvider = provider
}

extension DependencyValues {
  public var appleLoginUseCase: AppleLoginUseCase {
    get { self[AppleLoginUseCaseKey.self] }
    set { self[AppleLoginUseCaseKey.self] = newValue }
  }
}

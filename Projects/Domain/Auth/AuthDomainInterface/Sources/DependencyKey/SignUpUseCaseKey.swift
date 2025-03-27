//
//  SignUpUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum SignUpUseCaseKey: DependencyKey {
  public static var liveValue: SignUpUseCase { signUpUseCaseProvider() }
  public static var previewValue: SignUpUseCase { signUpUseCaseProvider() }
  public static var testValue: SignUpUseCase { signUpUseCaseProvider() }
}

var signUpUseCaseProvider: () -> SignUpUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func signUpUseCaseRegister(
  provider: @escaping () -> SignUpUseCase
) {
  signUpUseCaseProvider = provider
}

extension DependencyValues {
  public var signUpUseCase: SignUpUseCase {
    get { self[SignUpUseCaseKey.self] }
    set { self[SignUpUseCaseKey.self] = newValue }
  }
}

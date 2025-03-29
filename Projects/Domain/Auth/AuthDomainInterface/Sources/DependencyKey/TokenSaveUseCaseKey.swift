//
//  TokenSaveUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum TokenSaveUseCaseKey: DependencyKey {
  public static var liveValue: TokenSaveUseCase { tokenSaveUseCaseProvider() }
  public static var previewValue: TokenSaveUseCase { tokenSaveUseCaseProvider() }
  public static var testValue: TokenSaveUseCase { tokenSaveUseCaseProvider() }
}

var tokenSaveUseCaseProvider: () -> TokenSaveUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func tokenSaveUseCaseRegister(
  provider: @escaping () -> TokenSaveUseCase
) {
  tokenSaveUseCaseProvider = provider
}

extension DependencyValues {
  public var tokenSaveUseCase: TokenSaveUseCase {
    get { self[TokenSaveUseCaseKey.self] }
    set { self[TokenSaveUseCaseKey.self] = newValue }
  }
}


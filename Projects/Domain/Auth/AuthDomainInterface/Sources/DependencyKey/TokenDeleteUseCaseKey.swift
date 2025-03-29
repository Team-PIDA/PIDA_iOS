//
//  TokenDeleteUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum TokenDeleteUseCaseKey: DependencyKey {
  public static var liveValue: TokenDeleteUseCase { tokenDeleteUseCaseProvider() }
  public static var previewValue: TokenDeleteUseCase { tokenDeleteUseCaseProvider() }
  public static var testValue: TokenDeleteUseCase { tokenDeleteUseCaseProvider() }
}

var tokenDeleteUseCaseProvider: () -> TokenDeleteUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func tokenDeleteUseCaseRegister(
  provider: @escaping () -> TokenDeleteUseCase
) {
  tokenDeleteUseCaseProvider = provider
}

extension DependencyValues {
  public var tokenDeleteUseCase: TokenDeleteUseCase {
    get { self[TokenDeleteUseCaseKey.self] }
    set { self[TokenDeleteUseCaseKey.self] = newValue }
  }
}


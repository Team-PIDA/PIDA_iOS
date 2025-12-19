//
//  UpdateBloomingUseCaseKey.swift
//  BloomingDomainInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum UpdateBloomingUseCaseKey: DependencyKey {
  public static var liveValue: UpdateBloomingUseCase { updateBloomingUseCaseProvider() }
  public static var previewValue: UpdateBloomingUseCase { updateBloomingUseCaseProvider() }
  public static var testValue: UpdateBloomingUseCase { updateBloomingUseCaseProvider() }
}

var updateBloomingUseCaseProvider: () -> UpdateBloomingUseCase = {
  fatalError("UpdateBloomingUseCase Dependency not configured")
}

public func updateBloomingUseCaseRegister(
  provider: @escaping () -> UpdateBloomingUseCase
) {
  updateBloomingUseCaseProvider = provider
}

extension DependencyValues {
  public var updateBloomingUseCase: UpdateBloomingUseCase {
    get { self[UpdateBloomingUseCaseKey.self] }
    set { self[UpdateBloomingUseCaseKey.self] = newValue }
  }
}

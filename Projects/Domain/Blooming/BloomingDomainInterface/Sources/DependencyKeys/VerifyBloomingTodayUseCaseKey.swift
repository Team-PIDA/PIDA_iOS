//
//  VerifyBloomingTodayUseCaseKey.swift
//  BloomingDomainInterface
//
//  Created by 조용인 on 4/4/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum VerifyBloomingTodayUseCaseKey: DependencyKey {
  public static var liveValue: VerifyBloomingTodayUseCase { verifyBloomingTodayUseCaseProvider() }
  public static var previewValue: VerifyBloomingTodayUseCase { verifyBloomingTodayUseCaseProvider() }
  public static var testValue: VerifyBloomingTodayUseCase { verifyBloomingTodayUseCaseProvider() }
}

var verifyBloomingTodayUseCaseProvider: () -> VerifyBloomingTodayUseCase = {
  fatalError("UpdateBloomingUseCase Dependency not configured")
}

public func verifyBloomingTodayUseCaseResister(
  provider: @escaping () -> VerifyBloomingTodayUseCase
) {
  verifyBloomingTodayUseCaseProvider = provider
}

extension DependencyValues {
  public var verifyBloomingTodayUseCase: VerifyBloomingTodayUseCase {
    get { self[VerifyBloomingTodayUseCaseKey.self] }
    set { self[VerifyBloomingTodayUseCaseKey.self] = newValue }
  }
}


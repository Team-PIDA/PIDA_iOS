//
//  GetBloomingStateUseCaseKey.swift
//  BloomingDomainInterface
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum GetBloomingStateUseCaseKey: DependencyKey {
  public static var liveValue: GetBloomingStateUseCase { getBloomingStateUseCaseProvider() }
  public static var previewValue: GetBloomingStateUseCase { getBloomingStateUseCaseProvider() }
  public static var testValue: GetBloomingStateUseCase { getBloomingStateUseCaseProvider() }
}

var getBloomingStateUseCaseProvider: () -> GetBloomingStateUseCase = {
  fatalError("UpdateBloomingUseCase Dependency not configured")
}

public func getBloomingStateUseCaseResister(
  provider: @escaping () -> GetBloomingStateUseCase
) {
  getBloomingStateUseCaseProvider = provider
}

extension DependencyValues {
  public var getBloomingStateUseCase: GetBloomingStateUseCase {
    get { self[GetBloomingStateUseCaseKey.self] }
    set { self[GetBloomingStateUseCaseKey.self] = newValue }
  }
}

//
//  CalculateSimilarityScoreUseCaseKey.swift
//  SearchDomainInterface
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum CalculateSimilarityScoreUseCaseKey: DependencyKey {
  public static var liveValue: CalculateSimilarityScoreUseCase { calculateSimilarityScoreUseCaseProvider() }
  public static var previewValue: CalculateSimilarityScoreUseCase { calculateSimilarityScoreUseCaseProvider() } /// TODO: Add preview value
  public static var testValue: CalculateSimilarityScoreUseCase { calculateSimilarityScoreUseCaseProvider() } /// TODO: Add test value
}

var calculateSimilarityScoreUseCaseProvider: () -> CalculateSimilarityScoreUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func calculateSimilarityScoreUseCaseRegister(
  provider: @escaping () -> CalculateSimilarityScoreUseCase
) {
  calculateSimilarityScoreUseCaseProvider = provider
}

extension DependencyValues {
  public var calculateSimilarityScoreUseCase: CalculateSimilarityScoreUseCase {
    get { self[CalculateSimilarityScoreUseCaseKey.self] }
    set { self[CalculateSimilarityScoreUseCaseKey.self] = newValue }
  }
}

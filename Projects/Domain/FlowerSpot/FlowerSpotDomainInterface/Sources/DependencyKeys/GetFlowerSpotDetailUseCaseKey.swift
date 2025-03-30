//
//  GetFlowerSpotDetailUseCaseKey.swift
//  FlowerSpotDomainInterface
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum GetFlowerSpotDetailUseCaseKey: DependencyKey {
  public static var liveValue: GetFlowerSpotDetailUseCase { getFlowerSpotDetailUseCaseProvider() }
  public static var previewValue: GetFlowerSpotDetailUseCase { getFlowerSpotDetailUseCaseProvider() } /// TODO: Add preview value
  public static var testValue: GetFlowerSpotDetailUseCase { getFlowerSpotDetailUseCaseProvider() } /// TODO: Add test value
}

var getFlowerSpotDetailUseCaseProvider: () -> GetFlowerSpotDetailUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func getFlowerSpotDetailUseCaseRegister(
  provider: @escaping () -> GetFlowerSpotDetailUseCase
) {
  getFlowerSpotDetailUseCaseProvider = provider
}

extension DependencyValues {
  public var getFlowerSpotDetailUseCase: GetFlowerSpotDetailUseCase {
    get { self[GetFlowerSpotDetailUseCaseKey.self] }
    set { self[GetFlowerSpotDetailUseCaseKey.self] = newValue }
  }
}

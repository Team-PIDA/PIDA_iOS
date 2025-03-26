//
//  FetchAllFlowerPinUseCaseKey.swift
//  FlowerSpotDomain
//
//  Created by 조용인 on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchAllFlowerPinUseCaseKey: DependencyKey {
  public static var liveValue: FetchAllFlowerPinUseCase { fetchUsecaseProvider() }
  public static var previewValue: FetchAllFlowerPinUseCase { fetchUsecaseProvider() } /// TODO: Add preview value
  public static var testValue: FetchAllFlowerPinUseCase { fetchUsecaseProvider() } /// TODO: Add test value
}

var fetchUsecaseProvider: () -> FetchAllFlowerPinUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func fetchAllFlowerPinUseCaseRegister(
  provider: @escaping () -> FetchAllFlowerPinUseCase
) {
  fetchUsecaseProvider = provider
}

extension DependencyValues {
  public var fetchAllFlowerPinUseCase: FetchAllFlowerPinUseCase {
    get { self[FetchAllFlowerPinUseCaseKey.self] }
    set { self[FetchAllFlowerPinUseCaseKey.self] = newValue }
  }
}

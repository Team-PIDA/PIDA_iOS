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
  public static var liveValue: FetchAllFlowerPinUseCase { fetchAllFlowerPinUsecaseProvider() }
  public static var previewValue: FetchAllFlowerPinUseCase { fetchAllFlowerPinUsecaseProvider() } /// TODO: Add preview value
  public static var testValue: FetchAllFlowerPinUseCase { fetchAllFlowerPinUsecaseProvider() } /// TODO: Add test value
}

var fetchAllFlowerPinUsecaseProvider: () -> FetchAllFlowerPinUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func fetchAllFlowerPinUseCaseRegister(
  provider: @escaping () -> FetchAllFlowerPinUseCase
) {
  fetchAllFlowerPinUsecaseProvider = provider
}

extension DependencyValues {
  public var fetchAllFlowerPinUseCase: FetchAllFlowerPinUseCase {
    get { self[FetchAllFlowerPinUseCaseKey.self] }
    set { self[FetchAllFlowerPinUseCaseKey.self] = newValue }
  }
}

//
//  FetchAllFlowerAddressUseCaseKey.swift
//  FlowerSpotDomainInterface
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchAllFlowerAddressUseCaseKey: DependencyKey {
  public static var liveValue: FetchAllFlowerAddressUseCase { fetchAllFlowerAddressUseCaseProvider() }
  public static var previewValue: FetchAllFlowerAddressUseCase { fetchAllFlowerAddressUseCaseProvider() } /// TODO: Add preview value
  public static var testValue: FetchAllFlowerAddressUseCase { fetchAllFlowerAddressUseCaseProvider() } /// TODO: Add test value
}

var fetchAllFlowerAddressUseCaseProvider: () -> FetchAllFlowerAddressUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func fetchAllFlowerAddressUseCaseRegister(
  provider: @escaping () -> FetchAllFlowerAddressUseCase
) {
  fetchAllFlowerAddressUseCaseProvider = provider
}

extension DependencyValues {
  public var fetchAllFlowerAddressUseCase: FetchAllFlowerAddressUseCase {
    get { self[FetchAllFlowerAddressUseCaseKey.self] }
    set { self[FetchAllFlowerAddressUseCaseKey.self] = newValue }
  }
}

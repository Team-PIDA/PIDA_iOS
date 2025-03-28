//
//  FetchUserInfoUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchUserInfoUseCaseKey: DependencyKey {
  public static var liveValue: FetchUserInfoUseCase { fetchUserInfoUseCaseProvider() }
  public static var previewValue: FetchUserInfoUseCase { fetchUserInfoUseCaseProvider() }
  public static var testValue: FetchUserInfoUseCase { fetchUserInfoUseCaseProvider() }
}

var fetchUserInfoUseCaseProvider: () -> FetchUserInfoUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func fetchUserInfoUseCaseRegister(
  provider: @escaping () -> FetchUserInfoUseCase
) {
  fetchUserInfoUseCaseProvider = provider
}

extension DependencyValues {
  public var fetchUserInfoUseCase: FetchUserInfoUseCase {
    get { self[FetchUserInfoUseCaseKey.self] }
    set { self[FetchUserInfoUseCaseKey.self] = newValue }
  }
}

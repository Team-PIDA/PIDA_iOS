//
//  GetSearchListFromCacheUseCaseKey.swift
//  SearchDomainInterface
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum GetSearchListFromCacheUseCaseKey: DependencyKey {
  public static var liveValue: GetSearchListFromCacheUseCase { getSearchListFromCacheUseCaseProvider() }
  public static var previewValue: GetSearchListFromCacheUseCase { getSearchListFromCacheUseCaseProvider() } /// TODO: Add preview value
  public static var testValue: GetSearchListFromCacheUseCase { getSearchListFromCacheUseCaseProvider() } /// TODO: Add test value
}

var getSearchListFromCacheUseCaseProvider: () -> GetSearchListFromCacheUseCase = {
  fatalError("FetchAllFlowerPinUseCase Dependency not configured")
}

public func getSearchListFromCacheUseCaseRegister(
  provider: @escaping () -> GetSearchListFromCacheUseCase
) {
  getSearchListFromCacheUseCaseProvider = provider
}

extension DependencyValues {
  public var getSearchListFromCacheUseCase: GetSearchListFromCacheUseCase {
    get { self[GetSearchListFromCacheUseCaseKey.self] }
    set { self[GetSearchListFromCacheUseCaseKey.self] = newValue }
  }
}

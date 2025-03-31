//
//  FetchRecentSearchUseCaseKey.swift
//  SearchDomainInterface
//
//  Created by Jiyeon on 3/31/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchRecentSearchUseCaseKey: DependencyKey {
  public static var liveValue: FetchRecentSearchUseCase { fetchRecentSearchItemUseCaseProvider() }
  public static var previewValue: FetchRecentSearchUseCase { fetchRecentSearchItemUseCaseProvider() } /// TODO: Add preview value
  public static var testValue: FetchRecentSearchUseCase { fetchRecentSearchItemUseCaseProvider() } /// TODO: Add test value
}

var fetchRecentSearchItemUseCaseProvider: () -> FetchRecentSearchUseCase = {
  fatalError("fetchRecentSearchItemUseCase Dependency not configured")
}

public func fetchRecentSearchItemUseCaseRegister(
  provider: @escaping () -> FetchRecentSearchUseCase
) {
  fetchRecentSearchItemUseCaseProvider = provider
}

extension DependencyValues {
  public var fetchRecentSearchItemUseCase: FetchRecentSearchUseCase {
    get { self[FetchRecentSearchUseCaseKey.self] }
    set { self[FetchRecentSearchUseCaseKey.self] = newValue }
  }
}


//
//  SaveRecentSearchItemUseCaseKey.swift
//  SearchDomainInterface
//
//  Created by Jiyeon on 3/31/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum SaveRecentSearchItemUseCaseKey: DependencyKey {
  public static var liveValue: SaveRecentSearchItemUseCase { saveRecentSearchItemUseCaseProvider() }
  public static var previewValue: SaveRecentSearchItemUseCase { saveRecentSearchItemUseCaseProvider() } /// TODO: Add preview value
  public static var testValue: SaveRecentSearchItemUseCase { saveRecentSearchItemUseCaseProvider() } /// TODO: Add test value
}

var saveRecentSearchItemUseCaseProvider: () -> SaveRecentSearchItemUseCase = {
  fatalError("SaveRecentSearchItemUseCase Dependency not configured")
}

public func saveRecentSearchItemUseCaseRegister(
  provider: @escaping () -> SaveRecentSearchItemUseCase
) {
  saveRecentSearchItemUseCaseProvider = provider
}

extension DependencyValues {
  public var saveRecentSearchItemUseCase: SaveRecentSearchItemUseCase {
    get { self[SaveRecentSearchItemUseCaseKey.self] }
    set { self[SaveRecentSearchItemUseCaseKey.self] = newValue }
  }
}


//
//  LogoutUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum LogoutUseCaseKey: DependencyKey {
  public static var liveValue: LogoutUseCase { logoutUseCaseProvider() }
  public static var previewValue: LogoutUseCase { logoutUseCaseProvider() }
  public static var testValue: LogoutUseCase { logoutUseCaseProvider() }
}

var logoutUseCaseProvider: () -> LogoutUseCase = {
  fatalError("LogoutUseCase Dependency not configured")
}

public func logoutUseCaseRegister(
  provider: @escaping () -> LogoutUseCase
) {
  logoutUseCaseProvider = provider
}

extension DependencyValues {
  public var logoutUseCase: LogoutUseCase {
    get { self[LogoutUseCaseKey.self] }
    set { self[LogoutUseCaseKey.self] = newValue }
  }
}

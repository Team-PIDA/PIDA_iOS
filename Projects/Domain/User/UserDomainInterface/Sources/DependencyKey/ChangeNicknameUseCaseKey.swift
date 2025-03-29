//
//  ChangeNicknameUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

public enum ChangeNicknameUseCaseKey: DependencyKey {
  public static var liveValue: ChangeNicknameUseCase { changeNicknameUseCaseProvider() }
  public static var previewValue: ChangeNicknameUseCase { changeNicknameUseCaseProvider() }
  public static var testValue: ChangeNicknameUseCase { changeNicknameUseCaseProvider() }
}

var changeNicknameUseCaseProvider: () -> ChangeNicknameUseCase = {
  fatalError("FetchUserInfoUseCase Dependency not configured")
}

public func changeNicknameUseCaseRegister(
  provider: @escaping () -> ChangeNicknameUseCase
) {
  changeNicknameUseCaseProvider = provider
}

extension DependencyValues {
  public var changeNicknameUseCase: ChangeNicknameUseCase {
    get { self[ChangeNicknameUseCaseKey.self] }
    set { self[ChangeNicknameUseCaseKey.self] = newValue }
  }
}

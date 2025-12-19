//
//  SettingUseCaseImpl.swift
//
//  Setting
//
//  Created by JiYeon
//

import Foundation
import SettingDomainInterface

public struct SettingUseCaseImpl: SettingUseCase {
  private let repository: SettingRepository

  public init(
    repository: SettingRepository
  ) {
    self.repository = repository
  }

  public func execute() async throws -> Void { }
}

//
//  SettingUsecCase.swift
//
//  Setting
//
//  Created by JiYeon
//

import Foundation

public protocol SettingUseCase {
  func execute() async throws -> Void
}

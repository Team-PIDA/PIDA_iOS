//
//  SettingRepository.swift
//
//  Setting
//
//  Created by JiYeon
//

import Foundation

public protocol SettingRepository {
  func fetchData() async throws -> Void
}

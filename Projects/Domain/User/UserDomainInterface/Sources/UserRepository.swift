//
//  UserRepository.swift
//
//  User
//
//  Created by JiYeon
//

import Foundation

public protocol UserRepository {
  func fetchUserInfo() async throws -> UserInfoEntity
}

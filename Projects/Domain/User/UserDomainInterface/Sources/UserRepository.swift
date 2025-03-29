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
  func withdraw() async throws
  func changeNickname(nickname: String) async throws -> UserInfoEntity
}

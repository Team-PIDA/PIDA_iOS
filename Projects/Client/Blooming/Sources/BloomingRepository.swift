//
//  BloomingRepository.swift
//
//  Blooming
//
//  Created by JiYeon
//

import Foundation

public protocol BloomingRepository {
  func updateBlooming(id: Int, status: String) async throws
  func getBloomingState(id: Int) async throws -> BloomStatusEntity
  func verifyBloomingToday(id: Int) async throws -> VerifyBloomingStateEntity
}

//
//  BloomingRepository.swift
//
//  Blooming
//
//  Created by JiYeon
//

import Foundation

public protocol BloomingRepository {
  func fetchData() async throws -> Void
}

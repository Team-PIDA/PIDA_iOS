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
}

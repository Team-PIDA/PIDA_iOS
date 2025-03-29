//
//  BloomingUsecCase.swift
//
//  Blooming
//
//  Created by JiYeon
//

import Foundation

public protocol BloomingUseCase {
  func execute() async throws -> Void
}

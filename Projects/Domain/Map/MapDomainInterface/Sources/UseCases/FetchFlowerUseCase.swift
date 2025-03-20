//
//  MapUsecCase.swift
//
//  Map
//
//  Created by JiYeon
//

import Foundation

public protocol FetchFlowerUseCase {
  func execute() async throws -> [FlowerPosition]
}


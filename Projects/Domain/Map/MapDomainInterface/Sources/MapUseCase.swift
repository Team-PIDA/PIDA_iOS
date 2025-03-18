//
//  MapUsecCase.swift
//
//  Map
//
//  Created by JiYeon
//

import Foundation

public protocol MapUseCase {
  func fetchFlowers() async throws -> [FlowerPosition]
}


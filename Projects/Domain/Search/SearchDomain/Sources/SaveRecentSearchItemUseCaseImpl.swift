//
//  SaveRecentSearchItemUseCaseImpl.swift
//  SearchDomain
//
//  Created by Jiyeon on 3/31/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import SearchDomainInterface

public struct SaveRecentSearchItemUseCaseImpl: SaveRecentSearchItemUseCase {
  private let repository: SearchRepository
  
  public init(
    repository: SearchRepository
  ) {
    self.repository = repository
  }
  
  public func execute(spot: SearchListCellEntity) async throws {
    try await repository.saveRecentSearchToCache(spotItem: spot)
  }
}

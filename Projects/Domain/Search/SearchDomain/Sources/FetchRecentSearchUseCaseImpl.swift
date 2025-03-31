//
//  FetchRecentSearchUseCaseImpl.swift
//  SearchDomain
//
//  Created by Jiyeon on 3/31/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import SearchDomainInterface
import Utility

public struct FetchRecentSearchUseCaseImpl: FetchRecentSearchUseCase {
  private let repository: SearchRepository
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  public func execute() async throws -> [SearchListCellEntity] {
    return try await repository.fetchRecentSearchListFromCache().map {
      SearchListCellEntity(
        id: $0.id,
        address: $0.address,
        streetName: $0.streetName,
        subInfo: $0.date.toString(
          format: .mmdd
        )
      )
    }
  }
}

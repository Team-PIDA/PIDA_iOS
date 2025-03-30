//
//  GetSearchListFromCacheUseCaseImpl.swift
//
//  Search
//
//  Created by JiYeon
//

import Foundation
import SearchDomainInterface

public struct GetSearchListFromCacheUseCaseImpl: GetSearchListFromCacheUseCase {
  private let repository: SearchRepository
  
  public init(
    repository: SearchRepository
  ) {
    self.repository = repository
  }
  
  public func execute() async throws -> [SearchListCellEntity] {
    return try await repository.getSearchListFromCache().map {
      SearchListCellEntity(
        id: $0.id,
        address: $0.address,
        streetName: $0.streetName
      )
    }
  }
}

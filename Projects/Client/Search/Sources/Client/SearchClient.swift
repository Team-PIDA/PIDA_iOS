//
//  SearchClient.swift
//  SearchClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture

@DependencyClient
public struct SearchClient {
  public var calculateSimilarityScore: @Sendable (_ text: String?, _ query: String) throws -> Int
  public var fetchRecentSearch: @Sendable () async throws -> [PlaceSearchEntity]
  public var getSearchListFromCache: @Sendable () async throws -> [SearchListCellEntity]
  public var saveRecentSearchItem: @Sendable (_ item: PlaceSearchEntity) async throws -> Void
  public var fetchKeywordSearch: @Sendable (_ keyword: String) async throws -> [PlaceSearchEntity]
}

public extension DependencyValues {
  var searchClient: SearchClient {
    get { self[SearchClient.self]  }
    set { self[SearchClient.self] = newValue }
  }
}

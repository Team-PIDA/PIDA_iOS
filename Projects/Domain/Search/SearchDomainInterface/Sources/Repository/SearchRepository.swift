//
//  SearchRepository.swift
//  SearchDomainInterface
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Cache

public protocol SearchRepository {
  func getSearchListFromCache() async throws -> [AllFlowerSpotListModel]
  func saveRecentSearchToCache(spotItem: SearchListCellEntity) async throws -> Void
}

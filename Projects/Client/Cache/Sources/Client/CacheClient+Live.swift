//
//  CacheClient+Live.swift
//  CacheClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import Foundation

extension CacheClient: DependencyKey {
  public static var liveValue: CacheClient {
    let storage = TwoTierStorage()
    return CacheClient(
      _get: { await storage.getData(key: $0) },
      _set: { try await storage.setData(key: $0, data: $1, ttl: $2) },
      _remove: { await storage.remove(key: $0) },
      _removeAll: { await storage.removeAll() }
    )
  }
}

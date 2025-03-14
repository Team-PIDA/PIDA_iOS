//
//  URL+.swift
//  Utility
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public extension URL {
  func appendingPath(_ path: String?) throws -> URL {
    guard let path = path else { throw NSError(domain: "CLNetworker", code: 0, userInfo: nil) } // TODO: FoundationError로 변경
    return self.appendingPathComponent(path)
  }
  
  func appendingQueries(_ rawQuery: Encodable?) throws -> URL {
    guard let rawQuery = rawQuery else { throw NSError(domain: "CLNetworker", code: 0, userInfo: nil) } // TODO: FoundationError로 변경
    let encodedQuery = try rawQuery.toDictionary()
    let queries = encodedQuery.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
      throw NSError(domain: "CLNetworker", code: 0, userInfo: nil) // TODO: FoundationError로 변경
    }
    components.queryItems = queries
    guard let urlWithQueries = components.url else { throw NSError(domain: "CLNetworker", code: 0, userInfo: nil) } // TODO: FoundationError로 변경
    return urlWithQueries
  }
}

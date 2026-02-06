//
//  PlaceSearchQuery.swift
//  SearchClient
//
//  Created by Jiyeon on 2/1/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public struct PlaceSearchQuery: Encodable, Sendable {
  public let query: String
  
  public init(query: String) {
    self.query = query
  }
}
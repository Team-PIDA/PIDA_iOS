//
//  SearchClient+Endpoint.swift
//  SearchClient
//
//  Created by Jiyeon on 2/1/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient

struct SearchEndPoint: Sendable {
  static func searchPlaces(query: PlaceSearchQuery) -> Endpoint<PlaceSearchListDTO> {
    return Endpoint(
      method: .get,
      path: "/places/search",
      parameters: .query(query)
    )
  }
}

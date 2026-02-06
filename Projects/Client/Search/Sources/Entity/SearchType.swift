//
//  SearchType.swift
//  SearchClient
//
//  Created by Jiyeon on 2/2/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public enum SearchType: String, Codable, CaseIterable, Sendable {
  case district
  case landmark
  case flowerSpot
}

//
//  CategoryType.swift
//  CategoryClient
//
//  Created by PIDA on 3/12/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import DesignKit

public enum CategoryType: Equatable, Sendable {
  case all
  case event
  case trail
  case cafe
  case others(String)
}

extension CategoryType: RawRepresentable {
  public typealias RawValue = String

  public init(rawValue: String) {
    switch rawValue {
    case "ALL": self = .all
    case "EVENT": self = .event
    case "TRAIL": self = .trail
    case "CAFE": self = .cafe
    default: self = .others(rawValue)
    }
  }

  public var rawValue: String {
    switch self {
    case .all: return "ALL"
    case .event: return "EVENT"
    case .trail: return "TRAIL"
    case .cafe: return "CAFE"
    case .others(let value): return value
    }
  }
  
  public var spotType: MapSpotType {
    switch self {
    case .all:
      return .flower
    case .event:
      return .festival
    case .trail:
      return .steps
    case .cafe:
      return .cafe
    case .others:
      return .flower
    }
  }
}

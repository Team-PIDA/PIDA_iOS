//
//  CategoryType.swift
//  CategoryClient
//
//  Created by PIDA on 3/12/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public enum CategoryType: Equatable, Sendable {
  case all              // id: 0
  case festival         // id: 1
  case trail            // id: 2
  case cafe             // id: 3
  case unknown(Int)
}

extension CategoryType: RawRepresentable {
  public typealias RawValue = Int

  // TODO: API 스펙 확정 후 id 값 수정 필요
  public init(rawValue: Int) {
    switch rawValue {
    case 0: self = .all
    case 1: self = .festival
    case 2: self = .trail
    case 3: self = .cafe
    default: self = .unknown(rawValue)
    }
  }

  public var rawValue: Int {
    switch self {
    case .all: return 0
    case .festival: return 1
    case .trail: return 2
    case .cafe: return 3
    case .unknown(let id): return id
    }
  }
}

//
//  Data+.swift
//  Shared
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation

extension Data {
  public func decode<T: Decodable>(
    _ type: T.Type
  ) throws -> T {
    return try JSONDecoder().decode(type, from: self)
  }
}

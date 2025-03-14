//
//  Encodable+.swift
//  Utility
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public extension Encodable {
  func toDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    guard let convertedDict = jsonData as? [String: Any] else { throw NSError(domain: "Encodable", code: 0, userInfo: nil) } // TODO: FoundationError로 변경
    return convertedDict
  }
}

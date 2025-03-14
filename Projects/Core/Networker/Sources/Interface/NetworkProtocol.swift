//
//  NetworkProtocol.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol NetworkProtocol {
  func execute<E: APIRequestable>(with endpoint: E) async throws -> E.Response
}

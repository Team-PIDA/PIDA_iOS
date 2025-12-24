//
//  APIClient+.swift
//  NetworkClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Shared

extension APIClient: DependencyKey {
  public static var liveValue = APIClient(
      _execute: { try await Self.internalExecute($0) },
      upload: { try await Self.internalUpload($0, $1) },
      download: { try await Self.internalDownload($0) }
    )
}

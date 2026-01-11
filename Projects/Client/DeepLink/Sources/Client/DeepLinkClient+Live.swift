//
//  DeepLinkClient+Live.swift
//  DeepLinkClient
//
//  Created by 조용인
//  Copyright © com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture

extension DeepLinkClient: DependencyKey {
  public static let liveValue: Self = {
    let stream = AsyncStream<DeepLink>.makeStream()

    return Self(
      observe: { stream.stream },
      send: { deepLink in
        stream.continuation.yield(deepLink)
      }
    )
  }()
}

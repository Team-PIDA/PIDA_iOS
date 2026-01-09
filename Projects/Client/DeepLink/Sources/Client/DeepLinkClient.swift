//
//  DeepLinkClient.swift
//  DeepLinkClient
//
//  Created by 조용인
//  Copyright © com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture

@DependencyClient
public struct DeepLinkClient: Sendable {
  /// 딥링크 이벤트 스트림 구독
  public var observe: @Sendable () -> AsyncStream<DeepLink> = { .finished }

  /// 딥링크 이벤트 발송 (AppDelegate에서 호출)
  public var send: @Sendable (_ deepLink: DeepLink) async -> Void
}

public extension DependencyValues {
  var deepLinkClient: DeepLinkClient {
    get { self[DeepLinkClient.self] }
    set { self[DeepLinkClient.self] = newValue }
  }
}

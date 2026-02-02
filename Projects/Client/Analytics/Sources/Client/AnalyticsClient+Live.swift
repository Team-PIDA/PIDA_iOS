//
//  AnalyticsClient+Live.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import ComposableArchitecture
import Foundation

// MARK: - DependencyKey

extension AnalyticsClient: DependencyKey {
  public static let liveValue: AnalyticsClient = {
    let provider = MixpanelProvider()

    return AnalyticsClient(
      initialize: { token in
        provider.initialize(token: token)
      },
      track: { event in
        provider.track(event)
      },
      identify: { userId in
        provider.identify(userId: userId)
      },
      setUserProperties: { properties in
        provider.setUserProperties(properties)
      },
      reset: {
        provider.reset()
      },
      setSuperProperties: { properties in
        provider.setSuperProperties(properties)
      }
    )
  }()
}

// MARK: - Preview Value

extension AnalyticsClient {
  public static let previewValue: AnalyticsClient = {
    AnalyticsClient(
      initialize: { _ in },
      track: { event in
        #if DEBUG
        print("[Analytics Preview] \(event.name): \(event.properties)")
        #endif
      },
      identify: { _ in },
      setUserProperties: { _ in },
      reset: { },
      setSuperProperties: { _ in }
    )
  }()
}

//
//  MixpanelProvider.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import Foundation
import Mixpanel

// MARK: - MixpanelProvider

/// Mixpanel SDK 래핑 Provider
public final class MixpanelProvider: AnalyticsProvider, @unchecked Sendable {
  public init() {}

  public func initialize(token: String) {
    Mixpanel.initialize(token: token, trackAutomaticEvents: false)
  }

  public func track(_ event: any AnalyticsEvent) {
    let properties = convertToMixpanelProperties(event.properties)
    Mixpanel.mainInstance().track(event: event.name, properties: properties)

    #if DEBUG
    print("[Analytics] \(event.name): \(event.properties)")
    #endif
  }

  public func identify(userId: String) {
    Mixpanel.mainInstance().identify(distinctId: userId)
  }

  public func setUserProperties(_ properties: [String: Any]) {
    let mixpanelProperties = convertToMixpanelProperties(properties)
    Mixpanel.mainInstance().people.set(properties: mixpanelProperties)
  }

  public func reset() {
    Mixpanel.mainInstance().reset()
  }

  public func setSuperProperties(_ properties: [String: Any]) {
    let mixpanelProperties = convertToMixpanelProperties(properties)
    Mixpanel.mainInstance().registerSuperProperties(mixpanelProperties)
  }
}

// MARK: - Private Helpers

private extension MixpanelProvider {
  /// [String: Any]를 Mixpanel 호환 타입으로 변환
  func convertToMixpanelProperties(_ properties: [String: Any]) -> [String: MixpanelType] {
    properties.compactMapValues { value -> MixpanelType? in
      switch value {
      case let string as String:
        return string
      case let int as Int:
        return int
      case let double as Double:
        return double
      case let float as Float:
        return float
      case let bool as Bool:
        return bool
      case let date as Date:
        return date
      case let url as URL:
        return url
      case let array as [MixpanelType]:
        return array
      case let dict as [String: MixpanelType]:
        return dict
      default:
        return String(describing: value)
      }
    }
  }
}

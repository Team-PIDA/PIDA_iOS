//
//  SuperProperties.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import Foundation

// MARK: - SuperProperties

/// 모든 이벤트에 자동으로 포함되는 공통 속성
public struct SuperProperties: Sendable {
  public let userId: String?
  public let userLogin: Bool
  public let userRegion: String?
  public let appVersion: String
  public let osVersion: String
  public let deviceModel: String
  public let sessionId: String

  public init(
    userId: String?,
    userLogin: Bool,
    userRegion: String?,
    appVersion: String,
    osVersion: String,
    deviceModel: String,
    sessionId: String
  ) {
    self.userId = userId
    self.userLogin = userLogin
    self.userRegion = userRegion
    self.appVersion = appVersion
    self.osVersion = osVersion
    self.deviceModel = deviceModel
    self.sessionId = sessionId
  }

  /// Dictionary 변환
  public var asDictionary: [String: Any] {
    var dict: [String: Any] = [
      "user_login": userLogin,
      "app_version": appVersion,
      "os_version": osVersion,
      "device_model": deviceModel,
      "session_id": sessionId
    ]

    if let userId {
      dict["user_id"] = userId
    }

    if let userRegion {
      dict["user_region"] = userRegion
    }

    return dict
  }
}

// MARK: - SuperProperties Builder

public extension SuperProperties {
  /// 현재 기기 정보로 SuperProperties 생성
  static func current(
    userId: String?,
    userLogin: Bool,
    userRegion: String?,
    sessionId: String = UUID().uuidString
  ) -> SuperProperties {
    SuperProperties(
      userId: userId,
      userLogin: userLogin,
      userRegion: userRegion,
      appVersion: Bundle.main.appVersion,
      osVersion: ProcessInfo.processInfo.operatingSystemVersionString,
      deviceModel: DeviceInfo.modelName,
      sessionId: sessionId
    )
  }
}

// MARK: - Bundle Extension

private extension Bundle {
  var appVersion: String {
    infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
  }
}

// MARK: - DeviceInfo

private enum DeviceInfo {
  static var modelName: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }
}

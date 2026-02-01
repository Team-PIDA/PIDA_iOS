//
//  UserDefault+.swift
//  UserDefault+
//
//  Created by 조용인 on 12/19/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value: Sendable & Codable> {
  private let key: String
  private let defaultValue: Value?
  private let container: UserDefaults
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  
  public init(
    _ key: String,
    default defaultValue: Value? = nil,
    container: UserDefaults = .standard
  ) {
    self.key = key
    self.defaultValue = defaultValue
    self.container = container
  }
  
  public var wrappedValue: Value? {
    get {
      /// Data 로 저장된 경우 디코딩
      if let data = container.data(forKey: key) {
        return (try? decoder.decode(Value.self, from: data)) ?? defaultValue
      }
      /// 원시 타입인 경우 바로 캐스팅
      return container.object(forKey: key) as? Value ?? defaultValue
    }
    set {
      if let value = newValue {
        /// Codable 타입이면 JSON으로 인코딩
        if Value.self is any Encodable {
          if let data = try? encoder.encode(value) {
            container.set(data, forKey: key)
            return
          }
        }
        /// 원시타입 바로 저장
        container.set(value, forKey: key)
      } else {
        container.removeObject(forKey: key)
      }
    }
  }
}

public struct UserDefaultsKeys {

  // MARK: - User

  @UserDefault("accessToken", default: nil)
  public static var accessToken: String?

  @UserDefault("isLoggedIn", default: nil)
  public static var isLoggedIn: Bool?

  @UserDefault("username", default: nil)
  public static var username: String?

  @UserDefault("email", default: nil)
  public static var email: String?

  // MARK: - Device

  @UserDefault("deviceId", default: nil)
  public static var deviceId: String?

  // MARK: - Session Analytics

  @UserDefault("sessionStartTime", default: nil)
  public static var sessionStartTime: Date?

  @UserDefault("lastSessionEndTime", default: nil)
  public static var lastSessionEndTime: Date?
}

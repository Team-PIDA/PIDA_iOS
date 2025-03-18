//
//  UserDefault.swift
//  UserDefault
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

protocol UserDefaultProtocol: RawRepresentable where RawValue == String { }

extension UserDefaultProtocol {
  var rawValue: String { String(describing: self) }
  
  init?(rawValue: String) {
    self.init(rawValue: rawValue)
  }
  
  func save<T: Sendable & Decodable>(_ value: T?) {
    UserDefaults.standard.set(value, forKey: self.rawValue)
  }
  
  func load<T: Sendable & Decodable>() -> T? {
    return UserDefaults.standard.object(forKey: self.rawValue) as? T
  }
  
  func delete() {
    UserDefaults.standard.removeObject(forKey: self.rawValue)
  }
}

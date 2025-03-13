//
//  KeyChainWrapper.swift
//  KeyChain
//
//  Created by Jiyeon on 3/13/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 키체인 키 설정
public enum KeychainKey: String {
  case accessToken
}

public final class KeychainWrapper {
  public static let shared = KeychainWrapper()
  private init() {}
  
  private let bundleId = Bundle.main.bundleIdentifier ?? ""
  
  /// 키체인 저장 메서드
  ///
  /// 사용 예시:
  /// ```swift
  /// KeychainWrapper.shared.save("abcd1234", key: .accessToken)
  /// ```
  public func save<T: Codable>(_ value: T, forKey key: KeychainKey) -> Bool {
    do {
      let data = try JSONEncoder().encode(value)
      let query: [CFString: Any] = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: bundleId,
        kSecAttrAccount: key.rawValue,
        kSecValueData: data
      ]
      
      SecItemDelete(query as CFDictionary)
      
      let status = SecItemAdd(query as CFDictionary, nil) == errSecSuccess
      if !status {
        print("""
        [KeyChain Save Failed]
          - Key: \(key.rawValue)
          - Value: \(value)
        """)
      }
      return status
    } catch {
      print("""
      [KeyChain Save Error]
        - Key: \(key.rawValue)
        - Value: \(value)
        - Error: \(error.localizedDescription)
      """)
      return false
    }
    
  }
  
  /// 키체인 불러오기 메서드
  ///
  /// 사용 예시:
  /// ```swift
  /// var token: String? =
  ///   KeychainWrapper.shared.read(key: .accessToken)
  /// ```
  public func read<T: Codable>(forKey key: KeychainKey) -> T? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: bundleId,
      kSecAttrAccount: key.rawValue,
      kSecReturnData:  kCFBooleanTrue as Any,
      kSecMatchLimit: kSecMatchLimitOne
    ]
    
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    
    guard status == errSecSuccess, let data = dataTypeRef as? Data else {
      print("""
      [KeyChain Read Failed]
        - Key: \(key.rawValue)
      """)
      return nil
    }
    
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      print("""
      [KeyChain Read Error]
        - Key: \(key.rawValue)
        - Error: \(error.localizedDescription)
      """)
      return nil
    }
  }
  
  /// 키체인 수정 메서드
  ///
  /// 사용 예시:
  /// ```swift
  /// KeychainWrapper.shared.update("def", key: .accessToken)
  /// ```
  public func update<T: Codable>(_ value: T, forKey key: KeychainKey) -> Bool {
    do {
      let data = try JSONEncoder().encode(value)
      let query: [CFString: Any] = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: bundleId,
        kSecAttrAccount: key.rawValue
      ]
      let attribute: [CFString: Any] = [
        kSecValueData: data
      ]
      
      let status = SecItemUpdate(
        query as CFDictionary,
        attribute as CFDictionary
      ) == errSecSuccess
      if !status {
        print("""
        [KeyChain Update Failed]
          - Key: \(key.rawValue)
          - Value: \(value)
        """)
      }
      return status
    } catch {
      print("""
      [KeyChain Update Error]
        - Key: \(key.rawValue)
        - Value: \(value)
        - Error: \(error.localizedDescription)
      """)
      return false
    }
  }
  
  /// 키체인 삭제 메서드
  ///
  /// 사용 예시:
  /// ```swift
  /// KeychainWrapper.shared.delete(key: .accessToken)
  /// ```
  public func delete(forKey key: KeychainKey) -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: bundleId,
      kSecAttrAccount: key.rawValue
    ]
    let status = SecItemDelete(query as CFDictionary) == errSecSuccess
    if !status {
      print("""
      [KeyChain Delete Failed]
        - Key: \(key.rawValue)
      """)
    }
    return status
  }
  
}



//
//  CacheKey.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 캐시 키를 정의하는 구조체
public struct CacheKey<Namespace: CacheNamespace>: Hashable {
  public let namespace: Namespace
  public let identifier: String
  
  public init(
    _ namespace: Namespace,
    _ identifier: String
  ) {
    self.namespace = namespace
    self.identifier = identifier
  }
  
  /// 파일 이름으로 변환
  func toFileName() -> String {
    return "\(namespace.rawValue)_\(identifier).cache"
  }
  
  /// 파일 이름에서 캐시 키 생성 (성공하면 옵셔널 반환)
  ///
  /// - Parameters:
  ///   - fileName: 파일 이름
  ///
  /// - Example:
  ///   ```
  ///   let key = CacheKey.fromFileName("user_123.cache")
  ///   ```
  ///   이렇게 사용할 수 있습니다.
  static func fromFileName(
    _ fileName: String
  ) -> CacheKey<Namespace>? {
    guard let range = fileName.range(of: ".cache") else { return nil }
    let nameWithoutExtension = String(fileName[..<range.lowerBound])
    let components = nameWithoutExtension.split(separator: "_")
    guard components.count >= 2 else { return nil }
    
    let namespaceString = String(components[0])
    let identifier = components.dropFirst().joined(separator: "_")
    
    guard let namespace = Namespace(rawValue: namespaceString) else { return nil }
    return CacheKey(namespace, identifier)
  }
}

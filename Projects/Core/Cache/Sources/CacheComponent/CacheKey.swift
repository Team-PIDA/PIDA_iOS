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
}

public extension CacheKey {
  
  /// Disk Cache에 저장하기 위한 파일 이름 생성 (Memory Cache에는 사용되지 않음)
  /// - 생성되는 파일의 이름은 "{namespace}_{identifier}.cache" 형식입니다. (2개의 컴포넌트로 이루어짐)
  func toFileName() -> String { "\(namespace.rawValue)_\(identifier).cache" }
  
  
  /// 파일 이름으로부터 `CacheKey` 객체를 생성합니다. (`DiskCache`에서만 사용)
  static func fromFileName(
    _ fileName: String
  ) -> CacheKey<Namespace>? {
    guard let range = fileName.range(of: ".cache") else { return nil } /// 파일 확장자가 `.cache`인지 확인
    let fullnameWithoutExtension = String(fileName[..<range.lowerBound]) /// 확장자를 제외한 파일 이름 추출 ex) `"user_123"`
    let components = fullnameWithoutExtension.split(separator: "_") /// "_"를 기준으로 분리 ex) `["user", "123"]`
    guard components.count >= 2 else { return nil } /// 최소 2개 이상의 컴포넌트가 있어야 함 ( `{namespace}_{identifier}` 형식 )
    
    let namespaceString = String(components[0]) /// 첫 번째 컴포넌트가 `namespace` 이름
    let identifier = components.dropFirst().joined(separator: "_") /// 나머지 컴포넌트가 `identifier` 이름
    
    guard let namespace = Namespace(rawValue: namespaceString) else { return nil } /// `namespace` 이름을 `Namespace`로 변환
    return CacheKey(namespace, identifier) /// `CacheKey` 객체 생성
  }
}


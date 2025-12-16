//
//  CacheEntry.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 캐시 항목을 정의하는 구조체
/// - Value: 캐시할 값의 타입
/// - expiration: 캐시 만료 시점
/// - lastAccessed: 마지막 접근 시점
/// - createdAt: 캐시 항목 생성 시점
public struct CacheEntry<Value: Codable & Sendable>: Codable {
  public let value: Value
  public let expiration: Date
  public let lastAccessed: Date
  public let createdAt: Date
  
  public init(
    value: Value,
    expiration: Date,
    lastAccessed: Date = Date(),
    createdAt: Date = Date() // 생성 시점엔, 마지막 접근 시점과 동일함
  ) {
    self.value = value
    self.expiration = expiration
    self.lastAccessed = lastAccessed
    self.createdAt = createdAt
  }
  
  /// 만료 여부 확인
  public var isExpired: Bool { Date() > expiration }
  
  /// 마지막 접근 시점을 업데이트 하기 위해, 캐시 항목 접근 시 새로운 항목 생성
  public func accessed() -> CacheEntry<Value> {
    return CacheEntry(
      value: value,
      expiration: expiration,
      lastAccessed: Date(), // 업데이트된 마지막 접근 시점 설정
      createdAt: createdAt
    )
  }
}

//
//  DiskCacheStorage.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

// MARK: - Memory Cache Storage
actor DiskCacheStorage<Namespace: CacheNamespace, Value: Codable & Sendable>: CacheStorage {
  typealias Key = CacheKey<Namespace>
  
  private let fileManager = FileManager.default
  private let cacheDirectory: URL
  
  init(cacheName: String) throws {
    
    /// `~/Library/Caches` -> 특정 `Cache`를 저장하기 위한 Root Directory
    guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      throw CacheError.directoryCreationFailed
    }
    
    /// `~/Library/Caches/{cacheName}` -> 특정 `Cache`를 저장하기 위한 Directory
    self.cacheDirectory = cacheDir.appendingPathComponent(cacheName, isDirectory: true)
    
    /// `~/Library/Caches/{cacheName}` 디렉토리가 존재하지 않으면 생성합니다.
    if !fileManager.fileExists(atPath: cacheDirectory.path) {
      try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
  }
  
  /// `key`를 기반으로 `CacheEntry`를 저장합니다.
  /// - Parameters:
  ///  - entry: 저장할 `CacheEntry` - (실제 저장되는 `cache` 데이터)
  ///  - key: `CacheEntry`를 식별할 수 있는 `Key`
  ///
  /// - Note: 해당 method는 `background`에서 실행되어야 합니다. (async)
  func store(_ entry: CacheEntry<Value>, forKey key: Key) async throws {
    
    /// `~/Library/Caches/{cacheName}/{namespace}_{identifier}.cache` -> 특정 `CacheEntry`를 저장하기 위한 File URL
    let fileURL = cacheDirectory.appendingPathComponent(key.toFileName())
    
    /// `entry`를 JSON형태로 인코딩하여 저장합니다.
    do {
      let data = try JSONEncoder().encode(entry)
      try data.write(to: fileURL)
    } catch {
      throw CacheError.encodingFailed
    }
  }
  
  
  /// `key`를 기반으로 `CacheEntry`를 조회합니다.
  /// - Parameters:
  ///   - key: 조회할 `CacheEntry`를 식별할 수 있는 `Key`
  /// - Note: 해당 method는 `background`에서 실행되어야 합니다. (async)
  func retrieve(forKey key: Key) async throws -> CacheEntry<Value>? {
    
    /// `~/Library/Caches/{cacheName}/{namespace}_{identifier}.cache` -> 특정 `CacheEntry`가 저장된 File URL
    let fileURL = cacheDirectory.appendingPathComponent(key.toFileName())
    
    /// `fileURL`에 해당하는 파일이 존재하지 않으면 `nil`을 반환합니다.
    guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
    
    /// `fileURL`에 해당하는 파일을 읽어 `CacheEntry`로 디코딩합니다.
    do {
      let data = try Data(contentsOf: fileURL)
      let entry = try JSONDecoder().decode(CacheEntry<Value>.self, from: data)
      
      /// `CacheEntry`가 만료된 경우 파일을 삭제하고 `nil`을 반환합니다.
      if entry.isExpired {
        try? fileManager.removeItem(at: fileURL)
        return nil
      }
      
      return entry
    } catch {
      throw CacheError.decodingFailed
    }
  }
  
  /// `key`를 기반으로 `CacheEntry`를 삭제합니다.
  /// - Parameters:
  ///  - key: 삭제할 `CacheEntry`를 식별할 수 있는 `Key`
  /// - Note: 해당 method는 `background`에서 실행되어야 합니다. (async)
  func remove(forKey key: Key) async throws {
    
    /// `~/Library/Caches/{cacheName}/{namespace}_{identifier}.cache` -> 특정 `CacheEntry`를 저장하기 위한 File URL
    let fileURL = cacheDirectory.appendingPathComponent(key.toFileName())
    
    /// `fileURL`에 해당하는 파일이 존재하면 삭제합니다.
    if fileManager.fileExists(atPath: fileURL.path) {
      try fileManager.removeItem(at: fileURL)
    }
  }
  
  /// 모든 `CacheEntry`를 삭제합니다.
  /// - Note: 해당 method는 `background`에서 실행되어야 합니다. (async)
  func removeAll() async throws {
    
    /// `~/Library/Caches/{cacheName}` -> 특정 `Cache`를 저장하기 위한 Directory의 모든 파일을 조회합니다.
    let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
    for file in contents {
      try fileManager.removeItem(at: file)
    }
  }
  
  /// 만료된 `CacheEntry`를 삭제합니다.
  /// - Note: 해당 method는 `background`에서 실행되어야 합니다. (async)
  func removeExpired() async throws {
    
    /// `~/Library/Caches/{cacheName}` -> 특정 `Cache`를 저장하기 위한 Directory의 모든 파일을 조회합니다.
    let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
    
    /// 모든 파일을 순회하며 `CacheEntry`를 디코딩하고 `isExpired`를 확인합니다.
    /// 이후, 만료된 `CacheEntry`는 삭제합니다.
    for file in contents {
      do {
        let data = try Data(contentsOf: file)
        let entry = try JSONDecoder().decode(CacheEntry<Value>.self, from: data)
        if entry.isExpired { try fileManager.removeItem(at: file) }
      } catch {
        // 읽을 수 없는 파일은 삭제
        try? fileManager.removeItem(at: file)
      }
    }
  }
  
  /// 모든 `Key`를 조회합니다.
  /// - Note: 해당 method는 `background`에서 실행되어야 합니다. (async)
  func allKeys() async throws -> [Key] {
    
    /// `~/Library/Caches/{cacheName}` -> 특정 `Cache`를 저장하기 위한 Directory의 모든 파일을 조회합니다.
    let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
    var keys: [Key] = []
    
    for file in contents {
      let fileName = file.lastPathComponent
      /// `{namespace}_{identifier}.cache` -> `Key`로 변환 가능한 파일명인 경우 `Key`로 변환합니다.
      if let key = CacheKey<Namespace>.fromFileName(fileName) { keys.append(key) }
    }
    return keys
  }
}

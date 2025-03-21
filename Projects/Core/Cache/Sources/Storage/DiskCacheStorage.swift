//
//  DiskCacheStorage.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

// MARK: - Memory Cache <- 우선순위 낮음
actor DiskCacheStorage<Namespace: CacheNamespace, Value: Codable & Sendable>: CacheStorage {
  typealias Key = CacheKey<Namespace>
  
  private let fileManager = FileManager.default
  private let cacheDirectory: URL
  
  init(cacheName: String) throws {
    guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      throw CacheError.directoryCreationFailed
    }
    
    self.cacheDirectory = cacheDir.appendingPathComponent(cacheName, isDirectory: true)
    
    if !fileManager.fileExists(atPath: cacheDirectory.path) {
      try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
  }
  
  func store(_ entry: CacheEntry<Value>, forKey key: Key) async throws {
    let fileURL = cacheDirectory.appendingPathComponent(key.toFileName())
    
    do {
      let data = try JSONEncoder().encode(entry)
      try data.write(to: fileURL)
    } catch {
      throw CacheError.encodingFailed
    }
  }
  
  func retrieve(forKey key: Key) async throws -> CacheEntry<Value>? {
    let fileURL = cacheDirectory.appendingPathComponent(key.toFileName())
    
    guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
    
    do {
      let data = try Data(contentsOf: fileURL)
      let entry = try JSONDecoder().decode(CacheEntry<Value>.self, from: data)
      
      if entry.isExpired {
        try? fileManager.removeItem(at: fileURL)
        return nil
      }
      
      return entry
    } catch {
      throw CacheError.decodingFailed
    }
  }
  
  func remove(forKey key: Key) async throws {
    let fileURL = cacheDirectory.appendingPathComponent(key.toFileName())
    if fileManager.fileExists(atPath: fileURL.path) {
      try fileManager.removeItem(at: fileURL)
    }
  }
  
  func removeAll() async throws {
    let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
    for file in contents {
      try fileManager.removeItem(at: file)
    }
  }
  
  func removeExpired() async throws {
    let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
    
    for file in contents {
      do {
        let data = try Data(contentsOf: file)
        let entry = try JSONDecoder().decode(CacheEntry<Value>.self, from: data)
        
        if entry.isExpired {
          try fileManager.removeItem(at: file)
        }
      } catch {
        // 읽을 수 없는 파일은 삭제
        try? fileManager.removeItem(at: file)
      }
    }
  }
  
  func allKeys() async throws -> [Key] {
    let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
    var keys: [Key] = []
    
    for file in contents {
      let fileName = file.lastPathComponent
      if let key = CacheKey<Namespace>.fromFileName(fileName) {
        keys.append(key)
      }
    }
    
    return keys
  }
}

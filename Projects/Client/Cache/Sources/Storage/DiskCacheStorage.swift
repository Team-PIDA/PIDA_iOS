//
//  DiskStorage.swift
//  Cache
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation

// MARK: - DiskStorage

/// 디스크 기반 캐시 저장소
///
/// 파일 시스템을 사용한 영속적 캐시입니다.
/// 앱이 종료되어도 데이터가 유지되지만, 메모리 캐시보다 접근 속도가 느립니다.
///
/// ## 특징
/// - **영속성**: 앱 종료 후에도 데이터 유지
/// - **느린 속도**: 파일 I/O로 인해 메모리보다 느림
/// - **동시성 안전**: `actor`로 구현되어 thread-safe
///
/// ## 저장 위치
/// ```
/// ~/Library/Caches/PIDACache/
///   ├── userprofile.cache
///   ├── flowerspot_detail_123.cache
///   └── ...
/// ```
///
/// ## 사용처
/// - `TwoTierStorage`의 2차 캐시로 사용
/// - 직접 사용하지 말고 `CacheClient`를 통해 접근
///
/// - Note: 이 클래스는 내부 구현이므로 직접 사용하지 마세요.
actor DiskStorage {

  // MARK: - Properties

  private let fileManager = FileManager.default

  /// 캐시 파일이 저장되는 디렉토리
  /// `~/Library/Caches/AppCache/`
  private let cacheDirectory: URL

  // MARK: - Lifecycle

  init() {
    // 시스템 캐시 디렉토리 가져오기
    guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      fatalError("Cannot access cache directory")
    }

    // 앱 전용 캐시 하위 디렉토리 설정
    self.cacheDirectory = cacheDir.appendingPathComponent("PIDACache", isDirectory: true)

    // 디렉토리가 없으면 생성
    if !fileManager.fileExists(atPath: cacheDirectory.path) {
      try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
  }

  // MARK: - CRUD Operations

  /// 키에 해당하는 캐시 엔트리 조회
  ///
  /// 파일에서 데이터를 읽고 JSON 디코딩하여 반환합니다.
  /// 만료된 경우 파일을 삭제하고 `nil`을 반환합니다.
  func get(key: String) -> DataCacheEntry? {
    let fileURL = cacheDirectory.appendingPathComponent("\(key).cache")

    // 파일 존재 확인 및 읽기
    guard fileManager.fileExists(atPath: fileURL.path),
          let data = try? Data(contentsOf: fileURL),
          let entry = try? JSONDecoder().decode(DataCacheEntry.self, from: data) else {
      return nil
    }

    // 만료 체크
    if entry.isExpired {
      try? fileManager.removeItem(at: fileURL)
      return nil
    }

    return entry
  }

  /// 캐시 엔트리를 파일로 저장
  ///
  /// JSON 인코딩하여 `.cache` 확장자 파일로 저장합니다.
  func set(key: String, entry: DataCacheEntry) {
    let fileURL = cacheDirectory.appendingPathComponent("\(key).cache")

    guard let data = try? JSONEncoder().encode(entry) else { return }
    try? data.write(to: fileURL)
  }

  /// 특정 키의 캐시 파일 삭제
  func remove(key: String) {
    let fileURL = cacheDirectory.appendingPathComponent("\(key).cache")
    try? fileManager.removeItem(at: fileURL)
  }

  /// 모든 캐시 파일 삭제
  func removeAll() {
    guard let contents = try? fileManager.contentsOfDirectory(
      at: cacheDirectory,
      includingPropertiesForKeys: nil
    ) else { return }

    for file in contents {
      try? fileManager.removeItem(at: file)
    }
  }

  // MARK: - Expiration

  /// 만료된 캐시 파일 일괄 삭제
  ///
  /// 캐시 디렉토리의 모든 파일을 순회하며:
  /// 1. 읽을 수 없는 파일 → 삭제
  /// 2. 만료된 파일 → 삭제
  /// 3. 유효한 파일 → 유지
  ///
  /// `TwoTierStorage`의 타이머에 의해 주기적으로 호출됩니다.
  func removeExpired() {
    guard let contents = try? fileManager.contentsOfDirectory(
      at: cacheDirectory,
      includingPropertiesForKeys: nil
    ) else { return }

    for file in contents {
      // 파일 읽기 실패 시 삭제
      guard let data = try? Data(contentsOf: file),
            let entry = try? JSONDecoder().decode(DataCacheEntry.self, from: data) else {
        try? fileManager.removeItem(at: file)
        continue
      }

      // 만료된 항목 삭제
      if entry.isExpired {
        try? fileManager.removeItem(at: file)
      }
    }
  }
}

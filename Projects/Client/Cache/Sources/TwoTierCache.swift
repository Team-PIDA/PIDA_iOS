//
//  TwoTierStorage.swift
//  Cache
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation

// MARK: - TwoTierStorage

/// 2단계 캐시 저장소 (Memory + Disk)
///
/// 메모리와 디스크 두 계층으로 구성된 캐시 시스템입니다.
/// 메모리 캐시는 빠른 접근을, 디스크 캐시는 영속성을 제공합니다.
///
/// ## 동작 원리
///
/// ### 조회 흐름 (getData)
/// ```
/// 1. 메모리 캐시 확인
///    ├─ Hit → 데이터 반환 (가장 빠름)
///    └─ Miss → 디스크 캐시 확인
///              ├─ Hit → 메모리에 복사 후 반환
///              └─ Miss → nil 반환
/// ```
///
/// ### 저장 흐름 (setData)
/// ```
/// 데이터 저장 요청
///    ├─ 메모리에 저장 (빠른 접근용)
///    └─ 디스크에 저장 (영속성 보장)
/// ```
///
/// ## 메모리 관리 (LRU)
/// - 메모리 캐시는 최대 100개 항목으로 제한
/// - 초과 시 가장 오래 접근하지 않은 항목부터 제거 (LRU 정책)
/// - 디스크 캐시는 제한 없음 (TTL로만 관리)
///
/// ## 자동 정리
/// - 60초마다 백그라운드에서 만료된 항목 자동 삭제
/// - 앱 재시작 시에도 디스크 캐시는 유지됨
///
/// - Note: `actor`로 구현되어 동시성 안전(thread-safe)합니다.
actor TwoTierStorage {

  // MARK: - Properties

  /// 1차 캐시: 메모리 (빠른 접근)
  private let memoryStorage = MemoryStorage()

  /// 2차 캐시: 디스크 (영속성)
  private let diskStorage: DiskStorage

  /// 만료 항목 정리 타이머
  private var expirationTimer: Task<Void, Never>?

  /// 메모리 캐시 최대 항목 수 (LRU 임계값)
  private let maxMemoryCount = 100

  // MARK: - Lifecycle

  init() {
    self.diskStorage = DiskStorage()
    // 백그라운드에서 만료 항목 정리 시작
    Task.detached(priority: .background) { await self.startExpirationTimer() }
  }

  deinit {
    expirationTimer?.cancel()
  }

  // MARK: - Public API

  /// 캐시에서 데이터를 조회합니다.
  ///
  /// 조회 순서:
  /// 1. 메모리 캐시 확인 (빠름)
  /// 2. 디스크 캐시 확인 (느림, 하지만 영속적)
  ///
  /// 디스크에서 찾은 경우 메모리에도 복사하여 다음 조회를 빠르게 합니다.
  ///
  /// - Parameter key: 조회할 캐시 키
  /// - Returns: 캐시된 데이터, 없거나 만료된 경우 `nil`
  func getData(key: String) async -> Data? {
    // 1. Memory 먼저 확인 (빠름)
    if let entry = await memoryStorage.get(key: key) {
      if !entry.isExpired {
        // LRU를 위해 마지막 접근 시간 갱신
        let updated = entry.accessed()
        await memoryStorage.set(key: key, entry: updated)
        return entry.data
      } else {
        // 만료된 항목 삭제
        await memoryStorage.remove(key: key)
      }
    }

    // 2. Disk 확인 (메모리에 없는 경우)
    if let entry = await diskStorage.get(key: key) {
      if !entry.isExpired {
        // 디스크에서 찾은 데이터를 메모리에 복사 (다음 조회 가속화)
        let updated = entry.accessed()
        await memoryStorage.set(key: key, entry: updated)
        await diskStorage.set(key: key, entry: updated)
        await applyLRU()
        return entry.data
      } else {
        // 만료된 항목 삭제
        await diskStorage.remove(key: key)
      }
    }

    return nil
  }

  /// 캐시에 데이터를 저장합니다.
  ///
  /// 메모리와 디스크 모두에 저장하여 빠른 접근과 영속성을 동시에 보장합니다.
  ///
  /// - Parameters:
  ///   - key: 저장할 캐시 키
  ///   - data: 저장할 데이터
  ///   - ttl: 만료 시간
  func setData(key: String, data: Data, ttl: TTL) async throws {
    let expiration = Date().addingTimeInterval(ttl.timeInterval)
    let entry = DataCacheEntry(
      data: data,
      expiration: expiration,
      lastAccessed: Date(),
      createdAt: Date()
    )

    // 메모리 + 디스크 동시 저장
    await memoryStorage.set(key: key, entry: entry)
    await diskStorage.set(key: key, entry: entry)

    // 메모리 제한 초과 시 LRU 적용
    await applyLRU()
  }

  /// 특정 키의 캐시를 삭제합니다.
  func remove(key: String) async {
    await memoryStorage.remove(key: key)
    await diskStorage.remove(key: key)
  }

  /// 모든 캐시를 삭제합니다.
  func removeAll() async {
    await memoryStorage.removeAll()
    await diskStorage.removeAll()
  }

  // MARK: - Private Helpers

  /// LRU(Least Recently Used) 정책 적용
  ///
  /// 메모리 캐시가 `maxMemoryCount`를 초과하면
  /// 가장 오래 접근하지 않은 항목부터 제거합니다.
  ///
  /// - Note: 디스크 캐시에는 LRU를 적용하지 않습니다. (TTL로만 관리)
  private func applyLRU() async {
    let entries = await memoryStorage.allEntries()
    guard entries.count > maxMemoryCount else { return }

    // 마지막 접근 시간 기준 오름차순 정렬 (오래된 것이 앞에)
    let sorted = entries.sorted { $0.value.lastAccessed < $1.value.lastAccessed }

    // 초과분만큼 제거
    let toRemove = sorted.prefix(entries.count - maxMemoryCount)

    for (key, _) in toRemove {
      await memoryStorage.remove(key: key)
    }
  }

  /// 만료된 항목 자동 제거 타이머 시작
  ///
  /// 60초마다 메모리와 디스크에서 만료된 항목을 정리합니다.
  /// 백그라운드에서 실행되어 메인 스레드에 영향을 주지 않습니다.
  private func startExpirationTimer() {
    expirationTimer = Task.detached { [weak self] in
      while !Task.isCancelled {
        // 60초 대기
        try? await Task.sleep(nanoseconds: 60_000_000_000)
        guard let self = self else { return }
        // 만료 항목 정리
        await self.memoryStorage.removeExpired()
        await self.diskStorage.removeExpired()
      }
    }
  }
}

// MARK: - DataCacheEntry

/// 캐시 항목을 저장하는 내부 구조체
///
/// 실제 데이터와 메타데이터(만료 시간, 접근 시간 등)를 함께 저장합니다.
/// 디스크 저장을 위해 `Codable`을 준수합니다.
struct DataCacheEntry: Codable {

  /// 캐시된 실제 데이터
  let data: Data

  /// 만료 시점
  let expiration: Date

  /// 마지막 접근 시점 (LRU 정책에 사용)
  let lastAccessed: Date

  /// 생성 시점
  let createdAt: Date

  /// 만료 여부 확인
  var isExpired: Bool { Date() > expiration }

  /// 접근 시간을 현재로 갱신한 새 엔트리 반환
  ///
  /// 구조체는 불변이므로 새 인스턴스를 생성합니다.
  func accessed() -> DataCacheEntry {
    DataCacheEntry(
      data: data,
      expiration: expiration,
      lastAccessed: Date(),
      createdAt: createdAt
    )
  }
}

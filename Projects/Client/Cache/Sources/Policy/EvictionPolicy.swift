//
//  EvictionPolicy.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 캐시 제거 정책
/// - none: 별도의 제거 정책 X (만료 시간만 고려)
/// - lru: LRU 기반, 최대 개수 지정
/// - fifo: FIFO 기반, 최대 개수 지정
/// - size: 최대 사이즈 지정 (바이트 단위)
public enum EvictionPolicy {
    case none           // 별도의 제거 정책 X (만료 시간만 고려)
    case lru(Int)       // LRU 기반, 최대 개수 지정
    case fifo(Int)      // FIFO 기반, 최대 개수 지정
    case size(Int)      // 최대 사이즈 지정 (바이트 단위)
}

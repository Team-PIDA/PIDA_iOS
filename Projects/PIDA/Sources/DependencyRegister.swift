//
//  DependencyManager.swift
//  PIDA
//
//  Created by Jiyeon on 3/18/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

import MapDomainInterface
import MapDomain

enum DependencyRegistry {
  static func registerDependencies() {
    fetchFlowerUseCaseRegister(
      provider: { FetchFlowerUseCaseImpl() }
    )
    // 다른 의존성도 여기서 등록
  }
}

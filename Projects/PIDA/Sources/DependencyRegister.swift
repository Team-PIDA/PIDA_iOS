//
//  DependencyManager.swift
//  PIDA
//
//  Created by Jiyeon on 3/18/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker

import MapDomain
import FlowerSpotDomainInterface
import FlowerSpotDomain
import FlowerSpotDataInterface
import FlowerSpotData


enum DependencyRegistry {
  static func registerDependencies() {
    let networker = Networker()
    let flowerSpotRepository = FlowerSpotRepositoryImpl(networker: networker)
    
    fetchAllFlowerPinUseCaseRegister {
      FetchAllFlowerPinUseCaseImpl(
        repository: flowerSpotRepository
      )
    }
    // 다른 의존성도 여기서 등록
  }
}

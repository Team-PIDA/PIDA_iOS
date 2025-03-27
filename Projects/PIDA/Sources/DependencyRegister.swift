//
//  DependencyManager.swift
//  PIDA
//
//  Created by Jiyeon on 3/18/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker

import MapDomainInterface
import MapDomain
import FlowerSpotDomainInterface
import FlowerSpotDomain
import FlowerSpotDataInterface
import FlowerSpotData


import AuthDomainInterface
import AuthDomain
import AuthDataInterface
import AuthData

enum DependencyRegistry {
  static func registerDependencies() {
    let networker = Networker()
    let flowerSpotRepository = FlowerSpotRepositoryImpl(networker: networker)
    let authRepository = AuthRepositoryImpl(network: networker)
    
    fetchFlowerUseCaseRegister(
      provider: { FetchFlowerUseCaseImpl() }
    )
    fetchAllFlowerPinUseCaseRegister {
      FetchAllFlowerPinUseCaseImpl(
        repository: flowerSpotRepository
      )
    }
    
    appleLoginUseCaseRegister(
      provider: {
        AppleLoginUseCaseImpl(repository: authRepository)
      }
    )
    
    signUpUseCaseRegister(
      provider: { SignUpUseCaseImpl(repository: authRepository) }
    )
    
  }
}

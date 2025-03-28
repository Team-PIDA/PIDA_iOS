//
//  DependencyManager.swift
//  PIDA
//
//  Created by Jiyeon on 3/18/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker

import FlowerSpotDomainInterface
import FlowerSpotDomain
import FlowerSpotDataInterface
import FlowerSpotData


import AuthDomainInterface
import AuthDomain
import AuthDataInterface
import AuthData

import UserDomainInterface
import UserDomain
import UserDataInterface
import UserData

enum DependencyRegistry {
  static func registerDependencies() {
    let networker = Networker()
    let flowerSpotRepository = FlowerSpotRepositoryImpl(networker: networker)
    let authRepository = AuthRepositoryImpl(network: networker)
    let userRepository = UserRepositoryImpl(network: networker)
    
    // MARK: - Flower
    
    fetchAllFlowerPinUseCaseRegister {
      FetchAllFlowerPinUseCaseImpl(
        repository: flowerSpotRepository
      )
    }
    
    // MARK: - Auth
    
    appleLoginUseCaseRegister(
      provider: {
        AppleLoginUseCaseImpl(repository: authRepository)
      }
    )
    signUpUseCaseRegister(
      provider: { SignUpUseCaseImpl(repository: authRepository) }
    )
    tokenSaveUseCaseRegister(
      provider: { TokenSaveUseCaseImpl() }
    )
    tokenDeleteUseCaseRegister(
      provider: { TokenDeleteUseCaseImpl() }
    )
    
    // MARK: - User
    
    fetchUserInfoUseCaseRegister(
      provider: { FetchUserInfoUseCaseImpl(reporsitory: userRepository) }
    )
    
    
  }
}

//
//  BloomingRepositoryImpl.swift
//
//  Blooming
//
//  Created by JiYeon
//

import Foundation
import BloomingDataInterface
import BloomingDomainInterface
import Networker

public struct BloomingRepositoryImpl: BloomingRepository {
  private let network: NetworkProtocol

  public init(
    network: NetworkProtocol
  ) {
    self.network = network
  }

  public func fetchData() async throws -> Void { }
}

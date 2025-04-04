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

  public func updateBlooming(id: Int, status: String) async throws {
    let endpoint = BloomingEndPoint.updateBlooming(
      body: .init(
        flowerSpotId: id,
        status: status
      )
    )
    return try await network.execute(with: endpoint, timeout: 60).toEntity()
  }
  
  public func getBloomingState(id: Int) async throws -> BloomStatusEntity {
    let endpoint = BloomingEndPoint.getBloomingState(id: id)
    return try await network.execute(with: endpoint, timeout: 60).toEntity()
  }
}

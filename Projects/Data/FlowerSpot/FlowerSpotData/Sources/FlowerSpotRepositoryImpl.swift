//
//  FlowerSpotRepositoryImpl.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation
import FlowerSpotDataInterface
import FlowerSpotDomainInterface
import Core

public struct FlowerSpotRepositoryImpl: FlowerSpotRepository {
  private let networker: PIDANetworkProtocol

  public init(
    networker: PIDANetworkProtocol
  ) {
    self.networker = networker
  }

  public func fetchData() async throws -> Void { }
}

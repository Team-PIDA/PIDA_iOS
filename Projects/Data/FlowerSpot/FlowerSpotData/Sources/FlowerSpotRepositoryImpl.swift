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
import Networker

public struct FlowerSpotRepositoryImpl: FlowerSpotRepository {
  private let networker: NetworkProtocol

  public init(
    networker: NetworkProtocol
  ) {
    self.networker = networker
  }

  public func getFlowerSpotList(
    지역: String,
    남서쪽_위도: Double,
    남서쪽_경도: Double,
    북동쪽_위도: Double,
    북동쪽_경도: Double
  ) async throws -> FlowerSpotListEntity {
    let endpoint = FlowerSpotEndpoint.getFlowerSpotWithArea(
      getFlowerSpotParameter: .init(
        지역: 지역,
        남서쪽_위도: 남서쪽_위도,
        남서쪽_경도: 남서쪽_경도,
        북동쪽_위도: 북동쪽_위도,
        북동쪽_경도: 북동쪽_경도
      )
    )
    return try await networker.execute(with: endpoint, timeout: 60).toEntity()
  }
}

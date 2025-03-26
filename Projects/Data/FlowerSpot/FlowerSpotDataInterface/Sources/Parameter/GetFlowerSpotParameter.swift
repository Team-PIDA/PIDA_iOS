//
//  GetFlowerSpotParameter.swift
//  FlowerSpotDataInterface
//
//  Created by 조용인 on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct GetFlowerSpotParameter: Encodable {
  let 지역: String
  let 남서쪽_위도: Double
  let 남서쪽_경도: Double
  let 북동쪽_위도: Double
  let 북동쪽_경도: Double
  
  public init(
    지역: String,
    남서쪽_위도: Double,
    남서쪽_경도: Double,
    북동쪽_위도: Double,
    북동쪽_경도: Double
  ) {
    self.지역 = 지역
    self.남서쪽_위도 = 남서쪽_위도
    self.남서쪽_경도 = 남서쪽_경도
    self.북동쪽_위도 = 북동쪽_위도
    self.북동쪽_경도 = 북동쪽_경도
  }
}

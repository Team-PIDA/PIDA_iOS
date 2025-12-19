//
//  StatusTypeData.swift
//  BloomingDomainInterface
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import DesignKit

public struct StatusTypeData {
  public let peopleCount: Int
  public let percentage: Int
  
  public init(
    peopleCount: Int,
    percentage: Int
  ) {
    self.peopleCount = peopleCount
    self.percentage = percentage
  }
}



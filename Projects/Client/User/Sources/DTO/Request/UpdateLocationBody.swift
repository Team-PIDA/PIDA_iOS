//
//  UpdateLocationBody.swift
//  UserClient
//
//  Created by 조용인 on 1/27/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public struct UpdateLocationBody: Encodable, Sendable {
  public let latitude: Double
  public let longitude: Double

  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}

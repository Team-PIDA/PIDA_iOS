//
//  LocationClient+Live.swift
//  LocationClient
//
//  Created by 조용인
//  Copyright © com.pida.me. All rights reserved.
//

import ComposableArchitecture

extension LocationClient: DependencyKey {
  public static var liveValue: Self {
    return .init()
  }
}

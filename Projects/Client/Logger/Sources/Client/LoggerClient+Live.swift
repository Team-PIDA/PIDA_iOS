//
//  LoggerClient+Live.swift
//  LoggerClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import ComposableArchitecture

extension LoggerClient: DependencyKey {
  public static var liveValue: Self {
    
    return .init()
  }
}

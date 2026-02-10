//
//  LoggerClient+Live.swift
//  LoggerClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import ComposableArchitecture
import OSLog

extension LoggerClient: DependencyKey {
  public static var liveValue: Self {
    let logger = OSLog(
      subsystem: Bundle.main.bundleIdentifier ?? "com.pida.me", 
      category: "PIDA"
    )
    
    return .init(
      log: { message, level in
        let osLogType: OSLogType
        switch level {
        case .debug:
          osLogType = .debug
        case .info:
          osLogType = .info
        case .notice:
          osLogType = .default
        case .error:
          osLogType = .error
        case .fault:
          osLogType = .fault
        }
        
        os_log("%{public}@", log: logger, type: osLogType, message)
      },
      logError: { errorInfo in
        let message = errorInfo.formatLogMessage()
        Self.liveValue.log(message, .error)
      }
    )
  }
}

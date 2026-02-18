//
//  Logger.swift
//  Shared
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import Foundation
import OSLog

public struct Logger: Sendable {
  
  private static let osLogger = OSLog(
    subsystem: Bundle.main.bundleIdentifier ?? "com.pida.me",
    category: "PIDA"
  )
  
  public static func log(_ message: String, level: LogLevel = .info) {
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
    
    os_log("%{public}@", log: osLogger, type: osLogType, message)
  }
  
  public static func log(_ loggable: Loggable, level: LogLevel = .info) {
    let message = loggable.logMessage()
    log(message, level: level)
  }
}
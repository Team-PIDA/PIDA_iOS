//
//  PolicyType.swift
//  SettingFeature
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Utility

public enum PolicyType {
  case terms
  case privacy
  
  public var title: String {
    switch self {
    case .terms:
      "서비스 이용약관"
    case .privacy:
      "개인정보 처리방침"
    }
  }
  
  public var url: URL? {
    switch self {
    case .terms:
      return ExternalURL.serviceTerm
    case .privacy:
      return ExternalURL.privacyTerm
    }
  }
}

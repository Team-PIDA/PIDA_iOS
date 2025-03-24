//
//  PolicyType.swift
//  SettingFeature
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

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
      URL(string: "https://wealthy-session-98c.notion.site/1b490c66759880b78f61f69e025ed10e?pvs=4")
    case .privacy:
      URL(string: "https://wealthy-session-98c.notion.site/1b490c66759880d19d11d78d1e4d1560?pvs=4")
    }
  }
}

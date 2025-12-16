//
//  Constant.swift
//  Utility
//
//  Created by 조용인 on 4/4/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public enum Constant {
  public static let naver_map_client_id = Bundle.main.infoDictionary?["NMCLIENTID"] as? String
  public static let base_url = Bundle.main.infoDictionary?["BASE_URL"] as? String
}

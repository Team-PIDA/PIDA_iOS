//
//  DeepLinkType.swift
//  DeepLinkClient
//
//  Created by 조용인
//  Copyright © com.pida.me. All rights reserved.
//

import Foundation

/// 서버에서 전달하는 딥링크 타입 식별자
public enum DeepLinkType: String, Sendable {
  case flowerSpot = "flower_spot"
  case setting = "setting"
}

/// 서버 payload의 키 이름
public enum DeepLinkKey: String, Sendable {
  case type = "type"
  case spotId = "spot_id"
}

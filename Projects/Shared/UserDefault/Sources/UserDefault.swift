//
//  UserDefault.swift
//  UserDefault
//
//  Created by 조용인 on 3/18/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// UserDefaults에 저장되는 키 값들을 정의한 열거형
/// 모든 UserDefaults 키를 한 곳에서 관리하여 문자열 오타로 인한 오류를 방지.
public enum UserDefault: UserDefaultProtocol {
  
  case _accessToken
  
  /// _accessToken 값을 쉽게 가져오고 저장할 수 있는 정적 프로퍼티.
  ///
  ///
  /// 값을 저장할 때 -> `UserDefault.accessToken = "access_token"`
  /// 값을 가져올 때 -> `let token = UserDefault.accessToken`
  public static var accessToken: String? {
    get { Self._accessToken.load() }
    set {
      if newValue == nil { Self._accessToken.delete() }
      else { Self._accessToken.save(newValue) }
    }
  }
  
  /// 특정 키의 값을 UserDefaults에서 삭제하는 편의 메서드
  /// 사용 예: UserDefault.delete(._accessToken)
  public static func delete(_ key: Self) { key.delete() }
  
}

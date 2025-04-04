//
//  AlertType.swift
//  DesignKit
//
//  Created by Jiyeon on 3/25/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// SettingView에서 발생시킬 AlertView의 타입
public enum AlertType: Equatable {
  case logout
  case withdraw
  case login
  
  var title: String {
    switch self {
    case .logout: "정말 로그아웃할까요?"
    case .withdraw: "정말 탈퇴할까요?"
    case .login: "로그인이\n필요한 기능입니다."
    }
  }
  
  var message: String? {
    switch self {
    case .logout, .login: nil
    case .withdraw: "탈퇴하면 되돌릴 수 없어요."
    }
  }
  
  var cancel: String {
    return "취소"
  }
  
  var accept: String {
    switch self {
    case .logout: "로그아웃"
    case .login: "로그인하기"
    case .withdraw: "탈퇴하기"
    }
  }
}

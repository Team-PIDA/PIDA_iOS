//
//  NicknameValidType.swift
//  Utility
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
public enum NickNameInputValid: Equatable {
  case valid
  case tooShort
  case tooLong
  case none

  public var text: String? {
    switch self {
    case .valid: return "2~12자까지 입력할 수 있어요."
    case .tooShort: return "닉네임은 2자 이상 입력해주세요."
    case .tooLong: return "닉네임은 12자 이하로 입력해주세요."
    case .none: return "2~12자까지 입력할 수 있어요."
    }
  }
  
  public var isValid: Bool {
    self == .valid
  }
  
}

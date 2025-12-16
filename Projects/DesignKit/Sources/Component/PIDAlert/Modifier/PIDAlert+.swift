//
//  PIDAlert+.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// Alert Accept버튼 컬러 값 error 타입 여부 설정
///
/// - Default: false
public extension PIDAlert {
  func isErrorType(
    _ isError: Bool
  ) -> Self {
    var alert = self
    alert.isErrorType = isError
    return alert
  }
}

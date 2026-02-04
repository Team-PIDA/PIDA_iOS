//
//  PIDAlert+.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public extension PIDAlert {
  /// Alert Accept버튼 컬러 값 error 타입 여부 설정 (AlertType.isError로 자동 적용됨)
  ///
  /// - Default: AlertType.isError 값
  func isErrorType(
    _ isError: Bool
  ) -> Self {
    var alert = self
    alert.isErrorType = isError
    return alert
  }

  /// 취소 버튼 표시 여부 설정 (AlertType.showCancelButton으로 자동 적용됨)
  ///
  /// - Default: AlertType.showCancelButton 값
  func showCancelButton(
    _ show: Bool
  ) -> Self {
    var alert = self
    alert.showCancelButton = show
    return alert
  }
}

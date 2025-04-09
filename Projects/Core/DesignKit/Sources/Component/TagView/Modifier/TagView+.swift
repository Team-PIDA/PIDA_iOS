//
//  TagView+.swift
//  DesignKit
//
//  Created by 조용인 on 4/9/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public extension TagView {
  /// icon이 있는 태그를 생성합니다.
  /// - Parameter icon: icon에 적용 할 ImageSet
  /// - Returns: ImageSet이 적용된 Icon 반환
  func icon(
    _ icon: ImageSet
  ) -> Self {
    var tagView = self
    tagView.icon = Icon(image: icon).size(.small)
    return tagView
  }
}

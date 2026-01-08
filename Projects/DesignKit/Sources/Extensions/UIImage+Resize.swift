//
//  UIImage+Resize.swift
//  DesignKit
//
//  Created by 조용인 on 1/8/26.
//  Copyright 2025 com.yongin.pida. All rights reserved.
//

import UIKit

public extension UIImage {
  /// 최대 크기(픽셀)로 리사이징 (비율 유지)
  func resized(maxSize: CGFloat) -> UIImage? {
    let originalSize = self.size

    // 이미 작으면 그대로 반환
    guard originalSize.width > maxSize || originalSize.height > maxSize else {
      return self
    }

    // 비율 계산
    let ratio = min(maxSize / originalSize.width, maxSize / originalSize.height)
    let newSize = CGSize(
      width: originalSize.width * ratio,
      height: originalSize.height * ratio
    )

    // 리사이징
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    defer { UIGraphicsEndImageContext() }

    draw(in: CGRect(origin: .zero, size: newSize))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}

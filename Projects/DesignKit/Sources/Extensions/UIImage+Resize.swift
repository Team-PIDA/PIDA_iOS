//
//  UIImage+Resize.swift
//  DesignKit
//
//  Created by 조용인 on 1/8/26.
//  Copyright 2025 com.yongin.pida. All rights reserved.
//

import UIKit

public extension UIImage {
  /// 최대 크기(픽셀)로 리사이징 (비율 유지, Thread-safe)
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

    // UIGraphicsImageRenderer는 Thread-safe
    let renderer = UIGraphicsImageRenderer(size: newSize)
    return renderer.image { _ in
      draw(in: CGRect(origin: .zero, size: newSize))
    }
  }

  /// 리사이징 + JPEG 압축을 한 번에 처리 (Thread-safe)
  /// - Parameters:
  ///   - maxSize: 최대 픽셀 크기 (비율 유지)
  ///   - compressionQuality: JPEG 압축 품질 (0.0 ~ 1.0)
  /// - Returns: (리사이징된 이미지, JPEG 데이터) 튜플. 실패 시 nil
  func resizedJPEGData(
    maxSize: CGFloat,
    compressionQuality: CGFloat = 0.8
  ) -> (image: UIImage, data: Data)? {
    guard let resizedImage = resized(maxSize: maxSize),
          let jpegData = resizedImage.jpegData(compressionQuality: compressionQuality) else {
      return nil
    }
    return (resizedImage, jpegData)
  }
}

//
//  PhotoGalleryView.swift
//
//  FlowerSpotDetail
//
//  Created by 조용인
//

import SwiftUI
import DesignKit

/// 이미지 갤러리 화면 (2열 그리드)
public struct PhotoGalleryView: View {
  private let imageUrls: [String]
  private let title: String
  private let onImageTapped: ((Int) -> Void)?
  private let onBackTapped: (() -> Void)?

  public init(
    imageUrls: [String],
    title: String,
    onImageTapped: ((Int) -> Void)? = nil,
    onBackTapped: (() -> Void)? = nil
  ) {
    self.imageUrls = imageUrls
    self.title = title
    self.onImageTapped = onImageTapped
    self.onBackTapped = onBackTapped
  }

  public var body: some View {
    // TODO: 다음 Phase에서 구현
    Text("PhotoGalleryView - \(imageUrls.count)장")
      .navigationBarBackButtonHidden(true)
  }
}

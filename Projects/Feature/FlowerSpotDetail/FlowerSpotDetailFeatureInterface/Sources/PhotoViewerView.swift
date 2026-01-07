//
//  PhotoViewerView.swift
//
//  FlowerSpotDetail
//
//  Created by 조용인
//

import SwiftUI
import DesignKit

/// 이미지 상세 뷰어 (전체화면, Pinch 확대)
public struct PhotoViewerView: View {
  private let imageUrls: [String]
  private let currentIndex: Int
  private let onDismiss: (() -> Void)?
  private let onPreviousTapped: (() -> Void)?
  private let onNextTapped: (() -> Void)?
  private let onScaleChanged: ((CGFloat) -> Void)?

  public init(
    imageUrls: [String],
    currentIndex: Int,
    onDismiss: (() -> Void)? = nil,
    onPreviousTapped: (() -> Void)? = nil,
    onNextTapped: (() -> Void)? = nil,
    onScaleChanged: ((CGFloat) -> Void)? = nil
  ) {
    self.imageUrls = imageUrls
    self.currentIndex = currentIndex
    self.onDismiss = onDismiss
    self.onPreviousTapped = onPreviousTapped
    self.onNextTapped = onNextTapped
    self.onScaleChanged = onScaleChanged
  }

  public var body: some View {
    // TODO: 다음 Phase에서 구현
    ZStack {
      Color.black.ignoresSafeArea()
      Text("PhotoViewerView - \(currentIndex + 1)/\(imageUrls.count)")
        .foregroundColor(.white)
    }
    .onTapGesture {
      onDismiss?()
    }
  }
}

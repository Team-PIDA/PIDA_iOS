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
  private let isUIHidden: Bool
  private let onDismiss: (() -> Void)?
  private let onPreviousTapped: (() -> Void)?
  private let onNextTapped: (() -> Void)?
  private let onScaleChanged: ((CGFloat) -> Void)?

  public init(
    imageUrls: [String],
    currentIndex: Int,
    isUIHidden: Bool = false,
    onDismiss: (() -> Void)? = nil,
    onPreviousTapped: (() -> Void)? = nil,
    onNextTapped: (() -> Void)? = nil,
    onScaleChanged: ((CGFloat) -> Void)? = nil
  ) {
    self.imageUrls = imageUrls
    self.currentIndex = currentIndex
    self.isUIHidden = isUIHidden
    self.onDismiss = onDismiss
    self.onPreviousTapped = onPreviousTapped
    self.onNextTapped = onNextTapped
    self.onScaleChanged = onScaleChanged
  }

  public var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      // 이미지
      if currentIndex < imageUrls.count {
        RemoteImageView(urlString: imageUrls[currentIndex])
          .aspectRatio(contentMode: .fit)
      }

      // UI 오버레이 (확대 시 숨김)
      if !isUIHidden {
        VStack {
          topBar
          Spacer()
        }

        chevronButtons
      }
    }
  }

  // MARK: - Top Bar

  @ViewBuilder
  private var topBar: some View {
    NavigationBar(
      title: "\(currentIndex + 1)/\(imageUrls.count)",
      closeContent: {
        TouchArea(image: .close)
          .action {
            onDismiss?()
          }
          .size(.superLarge)
          .color(ColorSet.Icon.Inverse)
      }
    )
    .backgroundColor(.clear)
    .titleColor(.white)
  }

  // MARK: - Chevron Buttons

  @ViewBuilder
  private var chevronButtons: some View {
    HStack {
      // 왼쪽 쉐브론 (첫번째 이미지면 숨김)
      if currentIndex > 0 {
        chevronButton(direction: .left) {
          onPreviousTapped?()
        }
      } else {
        Color.clear.frame(width: 48, height: 48)
      }

      Spacer()

      // 오른쪽 쉐브론 (마지막 이미지면 숨김)
      if currentIndex < imageUrls.count - 1 {
        chevronButton(direction: .right) {
          onNextTapped?()
        }
      } else {
        Color.clear.frame(width: 48, height: 48)
      }
    }
    .padding(.horizontal, 16)
  }

  // MARK: - Chevron Button

  private enum ChevronDirection {
    case left, right

    var systemName: String {
      switch self {
      case .left: return "chevron.left"
      case .right: return "chevron.right"
      }
    }
  }

  @ViewBuilder
  private func chevronButton(direction: ChevronDirection, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Image(systemName: direction.systemName)
        .font(.system(size: 20, weight: .semibold))
        .foregroundColor(.white)
        .frame(width: 48, height: 48)
        .background(Color.black.opacity(0.4))
        .clipShape(Circle())
    }
  }
}

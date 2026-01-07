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

  // Pinch gesture 상태
  @State private var scale: CGFloat = 1.0
  @GestureState private var gestureScale: CGFloat = 1.0

  private let minScale: CGFloat = 1.0
  private let maxScale: CGFloat = 10.0

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

  private var currentScale: CGFloat {
    min(max(scale * gestureScale, minScale), maxScale)
  }

  public var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      // 이미지
      if currentIndex < imageUrls.count {
        RemoteImageView(urlString: imageUrls[currentIndex])
          .aspectRatio(contentMode: .fit)
          .scaleEffect(currentScale)
          .gesture(magnificationGesture)
          .onTapGesture(count: 2) {
            // 더블탭으로 확대/축소 토글
            withAnimation(.easeInOut(duration: 0.2)) {
              if scale > 1.0 {
                scale = 1.0
              } else {
                scale = 2.5
              }
            }
            onScaleChanged?(scale)
          }
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
    .onChange(of: currentIndex) { _, _ in
      // 이미지 전환 시 scale 초기화
      scale = 1.0
      onScaleChanged?(scale)
    }
  }

  // MARK: - Magnification Gesture

  private var magnificationGesture: some Gesture {
    MagnificationGesture()
      .updating($gestureScale) { value, state, _ in
        state = value
      }
      .onChanged { _ in
        onScaleChanged?(currentScale)
      }
      .onEnded { value in
        scale = min(max(scale * value, minScale), maxScale)
        onScaleChanged?(scale)
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

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

  // Pinch gesture 상태
  @State private var scale: CGFloat = 1.0
  @GestureState private var gestureScale: CGFloat = 1.0

  // Pan gesture 상태
  @State private var offset: CGSize = .zero
  @GestureState private var gestureOffset: CGSize = .zero

  // UI 표시 상태
  @State private var isUIVisible: Bool = true

  private let minScale: CGFloat = 1.0
  private let maxScale: CGFloat = 10.0

  public init(
    imageUrls: [String],
    currentIndex: Int,
    onDismiss: (() -> Void)? = nil,
    onPreviousTapped: (() -> Void)? = nil,
    onNextTapped: (() -> Void)? = nil
  ) {
    self.imageUrls = imageUrls
    self.currentIndex = currentIndex
    self.onDismiss = onDismiss
    self.onPreviousTapped = onPreviousTapped
    self.onNextTapped = onNextTapped
  }

  private var currentScale: CGFloat {
    min(max(scale * gestureScale, minScale), maxScale)
  }

  private var currentOffset: CGSize {
    CGSize(
      width: offset.width + gestureOffset.width,
      height: offset.height + gestureOffset.height
    )
  }

  public var body: some View {
    ZStack {
      // 배경 (싱글 탭으로 UI 토글)
      Color.black.ignoresSafeArea()
        .onTapGesture {
          withAnimation(.easeInOut(duration: 0.2)) {
            isUIVisible.toggle()
          }
        }

      // 이미지
      if currentIndex < imageUrls.count {
        RemoteImageView(urlString: imageUrls[currentIndex])
          .aspectRatio(contentMode: .fit)
          .scaleEffect(currentScale)
          .offset(currentOffset)
          .gesture(combinedGesture)
          .highPriorityGesture(
            TapGesture(count: 2)
              .onEnded {
                // 더블탭으로 확대/축소 토글
                withAnimation(.easeInOut(duration: 0.2)) {
                  if scale > 1.0 {
                    scale = 1.0
                    offset = .zero
                    isUIVisible = true
                  } else {
                    scale = 2.5
                    isUIVisible = false
                  }
                }
              }
          )
          .simultaneousGesture(
            TapGesture(count: 1)
              .onEnded {
                // 싱글 탭으로 UI 토글
                withAnimation(.easeInOut(duration: 0.2)) {
                  isUIVisible.toggle()
                }
              }
          )
      }

      // UI 오버레이
      if isUIVisible {
        VStack {
          topBar
          Spacer()
        }

        chevronButtons
      }
    }
    .onChange(of: currentIndex) { _, _ in
      // 이미지 전환 시 초기화
      scale = 1.0
      offset = .zero
      isUIVisible = true
    }
    .onChange(of: scale) { _, newScale in
      // 확대 시 UI 숨김, 축소 시 UI 표시
      if newScale > 1.0 && isUIVisible {
        withAnimation(.easeInOut(duration: 0.2)) {
          isUIVisible = false
        }
      } else if newScale <= 1.0 && !isUIVisible {
        withAnimation(.easeInOut(duration: 0.2)) {
          isUIVisible = true
        }
      }
    }
  }

  // MARK: - Gestures

  private var combinedGesture: some Gesture {
    SimultaneousGesture(magnificationGesture, dragGesture)
  }

  private var magnificationGesture: some Gesture {
    MagnificationGesture()
      .updating($gestureScale) { value, state, _ in
        state = value
      }
      .onEnded { value in
        scale = min(max(scale * value, minScale), maxScale)
        // 축소되면 offset 초기화
        if scale <= 1.0 {
          offset = .zero
        }
      }
  }

  private var dragGesture: some Gesture {
    DragGesture()
      .updating($gestureOffset) { value, state, _ in
        // 확대 상태에서만 드래그 허용
        if scale > 1.0 {
          state = value.translation
        }
      }
      .onEnded { value in
        if scale > 1.0 {
          // 확대 상태: 이미지 이동
          offset = CGSize(
            width: offset.width + value.translation.width,
            height: offset.height + value.translation.height
          )
        } else {
          // 1x 상태: 좌우 스와이프로 이미지 전환
          let threshold: CGFloat = 50
          if value.translation.width > threshold {
            // 오른쪽 스와이프 → 이전 이미지
            onPreviousTapped?()
          } else if value.translation.width < -threshold {
            // 왼쪽 스와이프 → 다음 이미지
            onNextTapped?()
          }
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

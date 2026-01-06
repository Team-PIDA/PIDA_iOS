//
//  BottomSheet.swift
//  DesignKit
//
//  Created by 조용인 on 3/31/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

// MARK: - New CherryBlossomBottomSheet (Generic)

public struct CherryBlossomBottomSheet<SmallContent: View, LargeContent: View>: View {

  // MARK: - Properties

  /// 바텀시트 최소 높이 (축소 상태)
  let minHeight: CGFloat
  /// 바텀시트 최대 높이 (확장 상태)
  let maxHeight: CGFloat
  /// 콘텐츠 전환 기준 높이
  let midHeight: CGFloat

  /// 축소 상태에서 보여줄 콘텐츠
  let smallContent: () -> SmallContent
  /// 확장 상태에서 보여줄 콘텐츠
  let largeContent: () -> LargeContent
  /// dismiss 시 호출되는 콜백
  let onDismiss: (() -> Void)?

  // MARK: - Internal State (View 전용)

  @State private var currentHeight: CGFloat
  @State private var isDragging: Bool = false
  @State private var initialHeight: CGFloat = 0

  /// 외부에서 드래그 가능 여부를 제어 (스크롤 ↔ 드래그 충돌 제어용)
  @Binding private var isDragEnabled: Bool

  // MARK: - Init

  public init(
    minHeight: CGFloat = 140,
    maxHeight: CGFloat = UIScreen.main.bounds.height - 100,
    midHeight: CGFloat? = nil,
    isDragEnabled: Binding<Bool>,
    @ViewBuilder smallContent: @escaping () -> SmallContent,
    @ViewBuilder largeContent: @escaping () -> LargeContent,
    onDismiss: (() -> Void)? = nil
  ) {
    self.minHeight = minHeight
    self.maxHeight = maxHeight
    self.midHeight = midHeight ?? (minHeight + maxHeight) / 2
    self.smallContent = smallContent
    self.largeContent = largeContent
    self.onDismiss = onDismiss
    self._currentHeight = State(initialValue: minHeight)
    self._isDragEnabled = isDragEnabled
  }

  // MARK: - Body

  public var body: some View {
    VStack {
      Spacer()
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .allowsHitTesting(false)
      sheetView
    }
    .ignoresSafeArea()
  }

  // MARK: - Sheet View

  private var sheetView: some View {
    VStack(spacing: .Number0) {
      handleIndicator
      contentView
    }
    .frame(height: currentHeight)
    .frame(maxWidth: .infinity)
    .background(ColorSet.Background.Primary)
    .cornerRadius(.Number16, corners: [.topLeft, .topRight])
    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    .gesture(isDragEnabled ? dragGesture() : nil)
  }

  // MARK: - Handle Indicator

  private var handleIndicator: some View {
    VStack {
      Spacer()
      RoundedRectangle(cornerRadius: .Number2)
        .fill(ColorSet.Gray._200)
        .frame(width: .Number80, height: .Number4)
        .padding(.bottom, .Number4)
    }
    .frame(maxWidth: .infinity)
    .contentShape(Rectangle())
    .frame(height: .Number20)
    .onTapGesture {
      withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
        currentHeight = currentHeight < midHeight ? maxHeight : minHeight
      }
    }
  }

  // MARK: - Content View

  @ViewBuilder
  private var contentView: some View {
    if currentHeight < midHeight {
      ScrollView(.vertical, showsIndicators: false) {
        smallContent()
      }
      .scrollDisabled(true)
      .frame(height: currentHeight - .Number20)
    } else {
      largeContent()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }

  // MARK: - Drag Gesture

  private func dragGesture() -> some Gesture {
    DragGesture(coordinateSpace: .global)
      .onChanged { value in
        if !isDragging {
          isDragging = true
          initialHeight = currentHeight
        }

        let translation = value.translation.height
        if translation > 0 {
          // 아래로 드래그 → 높이 감소
          currentHeight = max(minHeight, initialHeight - translation)
        } else {
          // 위로 드래그 → 높이 증가
          currentHeight = min(maxHeight, initialHeight - translation)
        }
      }
      .onEnded { value in
        isDragging = false

        // 드래그 속도 계산
        let velocity = value.predictedEndLocation.y - value.location.y

        // 빠른 아래 스와이프 → dismiss
        if velocity > 450 && currentHeight <= minHeight + 50 {
          onDismiss?()
          return
        }

        // 빠른 스와이프 감지 (threshold: 450)
        if abs(velocity) > 450 {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentHeight = velocity > 0 ? minHeight : maxHeight
          }
        } else {
          // 일반 드래그: 현재 위치 기준으로 결정
          withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentHeight = currentHeight > midHeight ? maxHeight : minHeight
          }
        }
      }
  }
}

// MARK: - Legacy CherryBlossomBottomSheet

@available(*, deprecated, message: "Use CherryBlossomBottomSheet<SmallContent, LargeContent> instead")
public struct CherryBlossomBottomSheetLegacy: View {
  public var title: String
  public var description: String
  public var tags: [TagCase]
  public var blossomState: BloomStatus
  public var isLoading: Bool
  public var onPullUp: (() async -> Void)?
  public var onPullDown: (() async -> Void)?
  public var onTap: (() async -> Void)?
  
  // MARK: Drag State
  @State private var dragOffset: CGFloat = 0
  private let sheetHeight: CGFloat = UIScreen.main.bounds.height
  private let safeAreaTop: CGFloat = UIApplication.shared.safeAreaTopInset
  private let collapsedHeight: CGFloat = 166 // sheet가 실제로 보여지는 높이
  private let pullThreshold: CGFloat = 80 // drag의 음/양 값이 이 값을 넘으면 pull down/up
  
  public init(
    title: String? = "",
    description: String? = "",
    tags: [TagCase?] = [],
    blossomState: BloomStatus? = nil,
    isLoading: Bool = false,
    onPullUp: (() async -> Void)? = nil,
    onPullDown: (() async -> Void)? = nil,
    onTap: (() async -> Void)? = nil
  ) {
    self.title = title ?? ""
    self.description = description ?? ""
    self.tags = tags.compactMap { $0 }
    self.blossomState = blossomState ?? .notBloomed
    self.isLoading = isLoading
    self.onPullUp = onPullUp
    self.onPullDown = onPullDown
    self.onTap = onTap
  }
  
  public var body: some View {
    content
  }
  
  private var content: some View {
    VStack(alignment: .leading, spacing: .Number0) {
      homeIndicator
      if isLoading { loadingView }
      else { mainInfoView }
      safeArea
    }
    .frame(height: sheetHeight)
    .background(ColorSet.Background.Primary)
    .cornerRadius(.Number20, corners: [.topLeft, .topRight])
    .offset(y: max(sheetHeight + dragOffset - collapsedHeight, safeAreaTop))
    .simultaneousGesture(
      TapGesture()
        .onEnded {
          Task { @MainActor in await onTap?() }
        }
    )
    .gesture(
      DragGesture()
        .onChanged { value in
          dragOffset = value.translation.height
        }
        .onEnded { value in
          print("드래그 끝났을 때, 이동 높이: \(-value.translation.height)")
          if -value.translation.height > pullThreshold {
            Task {@MainActor in await onPullUp?() }
          } else if value.translation.height > pullThreshold {
            Task {@MainActor in await onPullDown?() }
          }
          
          // 복귀 애니메이션
          withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            dragOffset = 0
          }
        }
    )
    .ignoresSafeArea(edges: .bottom)
    .transition(.move(edge: .bottom).combined(with: .opacity))
    .zIndex(1)
  }
  
  @ViewBuilder
  private var homeIndicator: some View {
    Rectangle()
      .frame(width: .Number80, height: .Number4)
      .cornerRadius(.Number2)
      .foregroundColor(ColorSet.Gray._200)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.top, .Number12)
  }
  
  @ViewBuilder
  private var mainInfoView: some View {
    VStack(alignment: .leading, spacing: .Number8) {
      VStack(alignment: .leading, spacing: .Number2) {
        HStack(spacing: .Number8) {
          Text(title)
            .fontStyle(FontSet.Heading.heading2)
            .foregroundColor(ColorSet.Text.Primary)
          
          HStack(spacing: 4) {
            GradiantIcon(image: .flower)
              .size(.large)
              .foregroundStyle(blossomState.gradiant)
            Text(blossomState.text)
              .fontStyle(FontSet.Label.label2)
              .foregroundColor(blossomState.textColor)
          }
        }
        
        Text(description)
          .fontStyle(FontSet.Body.body3)
          .foregroundColor(ColorSet.Text.Primary)
      }
      
      HStack(spacing: .Number4) {
        ForEach(tags, id: \.self) { tag in
          if case .informant = tag {
            TagView(text: tag.tagName)
              .icon(.verified)
          } else {
            TagView(text: tag.tagName)
          }
        }
      }
    }
    .padding(.horizontal, .Number16)
    .padding(.top, .Number20)
  }
  
  @ViewBuilder
  private var loadingView: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: ColorSet.Gray._300))
        Spacer()
      }
      Spacer()
    }
  }
  
  @ViewBuilder
  private var safeArea: some View {
    GeometryReader { geometry in
      Rectangle()
        .fill(ColorSet.Background.Primary)
        .frame(height: max(geometry.safeAreaInsets.bottom, 0))
        .ignoresSafeArea()
    }
  }
}

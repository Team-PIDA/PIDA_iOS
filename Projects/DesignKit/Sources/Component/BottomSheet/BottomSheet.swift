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
  /// 외부에서 확장/축소 상태를 제어
  @Binding private var isExpanded: Bool

  // MARK: - Init
  public init(
    minHeight: CGFloat = 140,
    maxHeight: CGFloat = UIScreen.main.bounds.height,
    midHeight: CGFloat? = nil,
    isDragEnabled: Binding<Bool>,
    isExpanded: Binding<Bool> = .constant(false),
    @ViewBuilder smallContent: @escaping () -> SmallContent,
    @ViewBuilder largeContent: @escaping () -> LargeContent,
    onDismiss: (() -> Void)? = nil
  ) {
    self.minHeight = minHeight
    self.maxHeight = maxHeight
    self.midHeight = midHeight ?? minHeight + (maxHeight - minHeight) / 3
    self.smallContent = smallContent
    self.largeContent = largeContent
    self.onDismiss = onDismiss
    self._currentHeight = State(initialValue: minHeight)
    self._isDragEnabled = isDragEnabled
    self._isExpanded = isExpanded
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
    .onChange(of: isExpanded) { _, newValue in
      withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
        currentHeight = newValue ? maxHeight : minHeight
      }
    }
    .onChange(of: currentHeight) { _, newValue in
      // currentHeight 변화에 따라 isExpanded 동기화
      let expanded = newValue >= midHeight
      if isExpanded != expanded {
        isExpanded = expanded
      }
    }
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
    .simultaneousGesture(shouldEnableDrag ? dragGesture() : nil)
  }

  /// 드래그 활성화 여부 결정
  /// - 축소 상태에서는 스크롤이 없으므로 항상 드래그 활성화
  /// - 확장 상태에서는 외부 바인딩(isDragEnabled)에 따라 결정
  private var shouldEnableDrag: Bool {
    currentHeight < midHeight ? true : isDragEnabled
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
    .offset(y: currentHeight >= midHeight ? -UIApplication.shared.safeAreaTopInset : 0)
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
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .scrollDisabled(true)
      .frame(height: currentHeight - .Number20)
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
          currentHeight = maxHeight
        }
      }
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
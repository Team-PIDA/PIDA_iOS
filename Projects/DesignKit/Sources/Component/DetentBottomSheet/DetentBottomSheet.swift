//
//  DetentBottomSheet.swift
//  DesignKit
//
//  Created by Jiyeon on 1/8/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI

public enum BottomSheetDetent: CaseIterable, Equatable {
  case low
  case twoThirds
  case high

  fileprivate static var ordered: [BottomSheetDetent] { [.low, .twoThirds, .high] }
}

public struct DetentBottomSheet<Content: View>: View {
  private let minHeight: CGFloat
  private let cornerRadius: CGFloat
  private let content: Content

  @Binding private var detent: BottomSheetDetent
  @Binding private var isPresent: Bool

  @State private var offset: CGFloat = 0
  @State private var lastOffset: CGFloat = 0

  private let presentAnimation = Animation.spring(
    response: 0.35,
    dampingFraction: 0.86,
    blendDuration: 0.1
  )

  private let snapAnimation = Animation.spring(
    response: 0.4,
    dampingFraction: 0.8
  )

  public init(
    isPresented: Binding<Bool>,
    minHeight: CGFloat = 100,
    cornerRadius: CGFloat = 30,
    detent: Binding<BottomSheetDetent> = .constant(.twoThirds),
    @ViewBuilder content: () -> Content
  ) {
    self._isPresent = isPresented
    self.minHeight = minHeight
    self.cornerRadius = cornerRadius
    self._detent = detent
    self.content = content()
  }

  public var body: some View {
    GeometryReader { proxy in
      let height = proxy.frame(in: .global).height
      let maxHeight = height - minHeight

      let snapOffsets = BottomSheetDetent.ordered.map {
        offset(for: $0, screenHeight: height, maxHeight: maxHeight)
      }

      ZStack(alignment: .bottom) {
        if isPresent {
          sheetView
            .offset(y: height - minHeight)
            .offset(y: clampedOffset(maxHeight: maxHeight))
            .gesture(dragGesture(maxHeight: maxHeight, snapOffsets: snapOffsets, screenHeight: height))
            .transition(.move(edge: .bottom))
            .onAppear {
              setOffset(to: detent, screenHeight: height, maxHeight: maxHeight)
            }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .animation(presentAnimation, value: isPresent)
      .onChange(of: detent) { _, newValue in
        guard isPresent else { return }
        withAnimation {
          setOffset(to: newValue, screenHeight: height, maxHeight: maxHeight)
        }
      }
    }
    .ignoresSafeArea(.all, edges: .bottom)
  }

  private var sheetView: some View {
    ZStack(alignment: .top) {
      Color.white
        .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: cornerRadius))

      VStack(spacing: 0) {
        Capsule()
          .fill(Color.gray)
          .frame(width: 80, height: 4)
          .padding(.top)

        content
      }
      .frame(maxHeight: .infinity, alignment: .top)
    }
  }

  // MARK: - Offset mapping

  private func setOffset(to detent: BottomSheetDetent, screenHeight: CGFloat, maxHeight: CGFloat) {
    offset = offset(for: detent, screenHeight: screenHeight, maxHeight: maxHeight)
    lastOffset = offset
  }

  private func offset(for detent: BottomSheetDetent, screenHeight: CGFloat, maxHeight: CGFloat) -> CGFloat {
    let targetVisible: CGFloat
    switch detent {
    case .low:       targetVisible = minHeight
    case .twoThirds: targetVisible = screenHeight * (2.0 / 3.0)
    case .high:      targetVisible = screenHeight
    }
    let raw = -(targetVisible - minHeight)
    return clamp(raw, min: -maxHeight, max: 0)
  }

  private func detent(forOffset current: CGFloat, screenHeight: CGFloat, maxHeight: CGFloat) -> BottomSheetDetent {
    BottomSheetDetent.ordered
      .map { ($0, offset(for: $0, screenHeight: screenHeight, maxHeight: maxHeight)) }
      .min(by: { abs($0.1 - current) < abs($1.1 - current) })?
      .0 ?? .low
  }

  private func clampedOffset(maxHeight: CGFloat) -> CGFloat {
    clamp(offset, min: -maxHeight, max: 0)
  }

  // MARK: - Gesture

  private func dragGesture(
    maxHeight: CGFloat,
    snapOffsets: [CGFloat],
    screenHeight: CGFloat
  ) -> some Gesture {
    DragGesture()
      .onChanged { value in
        // 드래그 중에도 offset을 계속 갱신 (메인스레드라 DQ 필요 없음)
        offset = clamp(lastOffset + value.translation.height, min: -maxHeight, max: 0)
      }
      .onEnded { _ in
        withAnimation(snapAnimation) {
          let snapped = nearestSnapOffset(current: offset, candidates: snapOffsets)
          offset = snapped
          lastOffset = snapped
          detent = detent(forOffset: snapped, screenHeight: screenHeight, maxHeight: maxHeight)
        }
      }
  }

  private func nearestSnapOffset(current: CGFloat, candidates: [CGFloat]) -> CGFloat {
    candidates.min(by: { abs($0 - current) < abs($1 - current) }) ?? current
  }

  private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    Swift.min(Swift.max(value, min), max)
  }
}

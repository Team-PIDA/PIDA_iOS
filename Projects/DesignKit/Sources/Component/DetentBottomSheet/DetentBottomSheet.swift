//
//  DetentBottomSheet.swift
//  DesignKit
//
//  Created by Jiyeon on 1/8/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI
public struct DetentBottomSheet<Content: View>: View {
  
  // 바텀시트 최소 노출 높이
  private let minHeight: CGFloat
  // 상단 코너 라운드 값
  private let cornerRadius: CGFloat
  // 외부에서 주입받는 시트 콘텐츠
  private let content: Content
  
  // 초기 detent 설정 값
  private let initialDetent: BottomSheetDetent
  // 현재 시트 높이 단계(detent)
  @Binding private var detent: BottomSheetDetent
  // 시트 표시 여부
  @Binding private var isPresent: Bool
  
  // 현재 시트 위치(offset)
  @State private var offset: CGFloat = 0
  // 드래그 시작 시점의 기준 offset
  @State private var lastOffset: CGFloat = 0
  
  // 등장 / 퇴장 애니메이션
  private let presentAnimation = Animation.spring(
    response: 0.35,
    dampingFraction: 0.86,
    blendDuration: 0.1
  )
  
  // detent 스냅 애니메이션
  private let snapAnimation = Animation.spring(
    response: 0.4,
    dampingFraction: 0.8
  )
  
  // 빠른 스와이프(플릭) 판단 임계값(포인트)
  private let flickThreshold: CGFloat = 200
  
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
    self.initialDetent = detent.wrappedValue
    self.content = content()
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let screenHeight = proxy.frame(in: .global).height
      let maxHeight = screenHeight - minHeight
      
      // 각 detent에 대응되는 offset 목록
      let snapOffsets = BottomSheetDetent.ordered.map {
        offset(for: $0, screenHeight: screenHeight, maxHeight: maxHeight)
      }
      
      ZStack(alignment: .bottom) {
        if isPresent {
          sheetView
            .offset(y: screenHeight - minHeight) // 바닥 기준 위치 (low 상태)
            .offset(y: clampedOffset(maxHeight: maxHeight)) // detent + 드래그 반영 위치
            .gesture(dragGesture(
              maxHeight: maxHeight,
              snapOffsets: snapOffsets,
              screenHeight: screenHeight
            ))
            .transition(.move(edge: .bottom))
            .onAppear { syncToDetent(screenHeight: screenHeight, maxHeight: maxHeight) }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .animation(presentAnimation, value: isPresent)
      .onChange(of: isPresent) { _, newValue in
        guard newValue else { return }

        // 다시 나타날 때 항상 초기 detent로 리셋
        detent = initialDetent
        syncToDetent(screenHeight: screenHeight, maxHeight: maxHeight)
      }
      .onChange(of: detent) { _, _ in
        // 외부에서 detent 변경 시 시트 위치 갱신
        guard isPresent else { return }
        withAnimation { syncToDetent(screenHeight: screenHeight, maxHeight: maxHeight) }
      }
    }
    .ignoresSafeArea(.all, edges: .bottom)
  }
  
  // MARK: - View
  
  private var sheetView: some View {
    ZStack(alignment: .top) {
      Color.white
        .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: cornerRadius))
      
      VStack(spacing: 0) {
        Capsule()
          .fill(Color.gray)
          .frame(width: 80, height: 4)
          .padding(.top)
        
        // 외부에서 주입된 콘텐츠
        content
      }
      .frame(maxHeight: .infinity, alignment: .top)
    }
  }
  
  // MARK: - Sync / Mapping
  
  // 현재 detent에 맞는 위치로 offset 상태 동기화
  private func syncToDetent(screenHeight: CGFloat, maxHeight: CGFloat) {
    let target = offset(for: detent, screenHeight: screenHeight, maxHeight: maxHeight)
    offset = target
    lastOffset = target
  }
  
  // detent → 실제 y offset 값 변환
  private func offset(for detent: BottomSheetDetent, screenHeight: CGFloat, maxHeight: CGFloat) -> CGFloat {
    let visible = detent.visibleHeight(minHeight: minHeight, screenHeight: screenHeight)
    let raw = -(visible - minHeight)
    return clamp(raw, min: -maxHeight, max: 0)
  }
  
  // 현재 offset 기준으로 가장 가까운 detent 계산
  private func detent(forOffset current: CGFloat, screenHeight: CGFloat, maxHeight: CGFloat) -> BottomSheetDetent {
    BottomSheetDetent.ordered
      .map { ($0, offset(for: $0, screenHeight: screenHeight, maxHeight: maxHeight)) }
      .min(by: { abs($0.1 - current) < abs($1.1 - current) })?
      .0 ?? .low
  }
  
  // offset 범위를 허용 영역으로 제한
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
        // 이전 위치(lastOffset) + 현재 이동량으로 시트 위치를 실시간 갱신
        offset = clamp(lastOffset + value.translation.height, min: -maxHeight, max: 0)
      }
      .onEnded { value in
        // 속도/이동 방향을 고려해 최종 detent(멈출 위치) 결정
        let result = resolveEndState(
          value: value,
          maxHeight: maxHeight,
          snapOffsets: snapOffsets,
          screenHeight: screenHeight
        )
        
        // 결정된 위치로 스프링 애니메이션과 함께 스냅
        withAnimation(snapAnimation) {
          offset = result.offset
          lastOffset = result.offset
          detent = result.detent
        }
      }
  }
  
  // MARK: - End State Resolver
  
  private func resolveEndState(
    value: DragGesture.Value,
    maxHeight: CGFloat,
    snapOffsets: [CGFloat],
    screenHeight: CGFloat
  ) -> (offset: CGFloat, detent: BottomSheetDetent) {
    
    // 드래그 종료 시점의 예측 위치를 기준으로
    // 빠른 플릭인지, 일반 드래그인지 판별
    let projected = clamp(lastOffset + value.predictedEndTranslation.height, min: -maxHeight, max: 0)
    let projectedDelta = projected - offset
    let isFlick = abs(projectedDelta) > flickThreshold
    
    if isFlick {
      // 플릭인 경우: 현재 detent 기준으로 방향에 맞는 '다음 단계'로 이동
      let current = detent(forOffset: offset, screenHeight: screenHeight, maxHeight: maxHeight)
      let next = adjacentDetent(from: current, goingUp: projectedDelta < 0)
      let targetOffset = offset(for: next, screenHeight: screenHeight, maxHeight: maxHeight)
      return (targetOffset, next)
    } else {
      // 일반 드래그: 현재 위치에서 가장 가까운 스냅 지점으로 이동
      let snapped = nearestSnapOffset(current: offset, candidates: snapOffsets)
      let targetDetent = detent(forOffset: snapped, screenHeight: screenHeight, maxHeight: maxHeight)
      return (snapped, targetDetent)
    }
  }
  
  // 현재 detent 기준으로 한 단계 위/아래 detent 반환
  private func adjacentDetent(
    from current: BottomSheetDetent,
    goingUp: Bool
  ) -> BottomSheetDetent {
    
    let ordered = BottomSheetDetent.ordered
    let idx = ordered.firstIndex(of: current) ?? 0
    let nextIdx = goingUp
    ? min(idx + 1, ordered.count - 1)
    : max(idx - 1, 0)
    
    return ordered[nextIdx]
  }
  
  // MARK: - Utils
  
  // 가장 가까운 스냅 위치 선택
  private func nearestSnapOffset(current: CGFloat, candidates: [CGFloat]) -> CGFloat {
    candidates.min(by: { abs($0 - current) < abs($1 - current) }) ?? current
  }
  
  // 값 범위 제한 유틸
  private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    Swift.min(Swift.max(value, min), max)
  }
}

// MARK: - fileprivate BottomSheetDetent Extension
extension BottomSheetDetent {
  fileprivate static let ordered: [BottomSheetDetent] = [.low, .twoThirds, .high]
  
  fileprivate func visibleHeight(minHeight: CGFloat, screenHeight: CGFloat) -> CGFloat {
    switch self {
    case .low:       return minHeight
    case .twoThirds: return screenHeight * (2.0 / 3.0)
    case .high:      return screenHeight
    }
  }
}

//
//  RatioBarView.swift
//  DesignKit
//
//  Created by Jiyeon on 4/2/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
struct RatioBarView: View {

  /// 개화 상태 별 비율
  private let ratios: [BloomStatus: CGFloat]
  /// 전체 비율
  private let total: CGFloat
  /// 최대 비율 상태
  private let maxRatios: [BloomStatus]
  /// 최대 비율의 동점 여부
  private let isTie: Bool
  /// 막대 간 간격
  private let spacing: CGFloat = .Number4
  
  private var graphCases: [BloomStatus] {
    [.little, .bloomed, .withered]
  }
  /// 그래프에 보여주기 위한 상태(0인 데이터의 상태 제거)
  private var activeStates: [BloomStatus] {
    graphCases.filter {
      (ratios[$0] ?? 0) > 0
    }
  }
  
  private var totalSpacing: CGFloat {
    CGFloat(max(0, activeStates.count - 1)) * spacing
  }
  
  // MARK: -  Initialize
  
  init(
    ratios: [BloomStatus: CGFloat],
    maxRatios: [BloomStatus],
    isTie: Bool
  ) {
    self.ratios = ratios
    self.maxRatios = maxRatios
    self.isTie = isTie
    self.total = ratios.values.reduce(0, +)
  }
  

  public var body: some View {
    GeometryReader { geometry in
      let fullWidth = geometry.size.width
      let availableWidth = fullWidth - totalSpacing

      ZStack(alignment: .leading) {
        Capsule()
          .fill(ColorSet.Background.Primary)

        if total > 0 {
          HStack(spacing: spacing) {
            ForEach(activeStates, id: \.self) { status in
              let value = ratios[status] ?? 0
              let ratio = value / total
              let fillColor = isTie
                ? status.inactiveColor
                : (maxRatios.contains(status) ? status.activeColor : status.inactiveColor)

              fillColor
                .frame(width: availableWidth * ratio, height: .Number8)
                .clipShape(Capsule())
            }
          }
        } else { // 데이터가 없을 경우
          Capsule()
            .fill(ColorSet.Background.Tertiary)
            .frame(width: fullWidth, height: .Number8)
        }
      }
    }
    .frame(height: .Number8)
  }
}

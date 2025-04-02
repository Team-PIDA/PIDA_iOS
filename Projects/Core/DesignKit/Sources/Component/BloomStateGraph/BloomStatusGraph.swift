//
//  BloomStatusGraph.swift
//  DesignKit
//
//  Created by Jiyeon on 4/2/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct BloomStatusGraph: View {
  private let ratios: [BloomStatus: CGFloat]
  private let maxRatioStatus: [BloomStatus]
  private let isTie: Bool
  private let maxRatioValue: Int
  private let maxVoteCount: Int
  private let date: String
  
  private var state: BloomStatus? {
    if maxRatioValue == 0 {
      return nil
    } else if isTie {
      return .notBloomed
    } else {
      return maxRatioStatus.first
    }
  }
  
  public init(
    date: String,
    little: Int = 0,
    bloomed: Int = 0,
    withered: Int = 0,
    maxVoteCount: Int = 0
  ) {
    self.date = date
    self.maxVoteCount = maxVoteCount
    self.ratios = [
      .little: CGFloat(little),
      .bloomed: CGFloat(bloomed),
      .withered: CGFloat(withered)
    ]
    let maxValue = ratios.values.max() ?? 0
    maxRatioValue = Int(maxValue)
    self.maxRatioStatus = ratios.filter {
      $0.value == maxValue && maxValue > 0
    }.map { $0.key }
    self.isTie = maxRatioStatus.count >= 2
  }
  
  public var body: some View {
    HStack(spacing: .Number4) {
      Text(date.relativeText())
        .fontStyle(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
        .frame(width: .Number40, alignment: .leading)
      bloomStateView
    }
  }
}

extension BloomStatusGraph {
  
  @ViewBuilder
  private var bloomStateView: some View {
    VStack(spacing: .Number8) {
      voteState
      RatioBarView(ratios: ratios, maxRatios: maxRatioStatus, isTie: isTie)
    }
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number12)
    .background(
      RoundedRectangle(cornerRadius: .Number10)
        .fill(ColorSet.Background.Primary)
        .stroke(
          ColorSet.Border.Secondary,
          lineWidth: .Number1
        )
    )
  }
  
  @ViewBuilder
  private var voteState: some View {
    HStack {
      flowerState
      Spacer()
      if state != .none {
        Text("\(maxRatioValue)%(\(maxVoteCount)명)")
          .fontStyle(FontSet.Caption.caption1)
          .foregroundStyle(ColorSet.Text.Tertiary)
      }
      
    }
  }
  
  @ViewBuilder
  private var flowerState: some View {
    HStack(spacing: .Number4) {
      if let state = self.state {
        GradiantIcon(image: .flower)
          .size(.small)
          .foregroundStyle(state.gradiant)
        Text(state == .notBloomed ? "동점이에요" : state.text)
          .fontStyle(FontSet.Label.label2)
          .foregroundStyle(state.textColor)
      } else {
        Text("데이터가 없어요")
          .fontStyle(FontSet.Label.label2)
          .foregroundStyle(ColorSet.Text.Disabled)
      }
    }
  }
}

#Preview {
  BloomStatusGraph(date: "2025-04-02", little: 10, bloomed: 20, withered: 70, maxVoteCount: 10)
    .padding(.horizontal)
  BloomStatusGraph(date: "2025-04-01", little: 60, bloomed: 10, withered: 30, maxVoteCount: 10)
    .padding(.horizontal)
  BloomStatusGraph(date: "2025-03-31", little: 20, bloomed: 60, withered: 20, maxVoteCount: 10)
    .padding(.horizontal)
  BloomStatusGraph(date: "2025-03-30", little: 20, bloomed: 40, withered: 40, maxVoteCount: 10)
    .padding(.horizontal)
  BloomStatusGraph(date: "2025-03-29", little: 0, bloomed: 0, withered: 0, maxVoteCount: 0)
    .padding(.horizontal)
}

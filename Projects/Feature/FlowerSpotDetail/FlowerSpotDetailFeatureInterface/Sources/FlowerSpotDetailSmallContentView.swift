//
//  FlowerSpotDetailSmallContentView.swift
//
//  FlowerSpotDetail
//
//  Created by Claude
//

import SwiftUI
import DesignKit
import FlowerSpotClient
import BloomingClient

/// 바텀시트 축소 상태에서 보여줄 콘텐츠
public struct FlowerSpotDetailSmallContentView: View {
  let flowerSpotData: FlowerSpotEntity
  let bloomingStatus: BloomStatusEntity?

  public init(
    flowerSpotData: FlowerSpotEntity,
    bloomingStatus: BloomStatusEntity?
  ) {
    self.flowerSpotData = flowerSpotData
    self.bloomingStatus = bloomingStatus
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: .Number8) {
      titleSection
      tagSection
    }
    .padding(.horizontal, .Number16)
    .padding(.top, .Number8)
    .padding(.bottom, .Number16)
  }

  // MARK: - Title Section

  @ViewBuilder
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: .Number2) {
      HStack(spacing: .Number8) {
        Text(flowerSpotData.streetName)
          .fontStyle(FontSet.Heading.heading2)
          .foregroundColor(ColorSet.Text.Primary)

        if let blooming = BloomStatus(rawValue: flowerSpotData.bloomingStatus) {
          HStack(spacing: 4) {
            GradiantIcon(image: .flower)
              .size(.large)
              .foregroundStyle(blooming.gradiant)
            Text(blooming.text)
              .fontStyle(FontSet.Label.label2)
              .foregroundColor(blooming.textColor)
          }
        }
      }

      Text(flowerSpotData.address)
        .fontStyle(FontSet.Body.body3)
        .foregroundColor(ColorSet.Text.Primary)
    }
  }

  // MARK: - Tag Section

  @ViewBuilder
  private var tagSection: some View {
    HStack(spacing: .Number4) {
      // 지역 태그
      TagView(text: flowerSpotData.district)

      // 최근 방문자 수 태그
      TagView(text: flowerSpotData.recentlyVisitedCountString)

      // 제보자 태그 (있을 경우)
      if let nickname = bloomingStatus?.nickname {
        TagView(text: nickname)
          .icon(.verified)
      }
    }
  }
}

// MARK: - Loading View

public struct FlowerSpotDetailSmallContentLoadingView: View {

  public init() {}

  public var body: some View {
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
    .frame(height: 100)
  }
}

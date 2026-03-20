//
//  FlowerSpotDetailSmallContentView.swift
//
//  FlowerSpotDetail
//
//  Created by 조용인
//

import SwiftUI
import DesignKit
import FlowerSpotClient
import BloomingClient
import CategoryClient

/// 바텀시트 축소 상태에서 보여줄 콘텐츠
public struct FlowerSpotDetailSmallContentView: View {
  let flowerSpotData: FlowerSpotEntity
  let bloomingStatus: BloomStatusEntity?
  let spotCategory: SpotCategory
  let festivalInfo: FestivalInfoEntity?
  let badges: [CategoryBadgeEntity]

  public init(
    flowerSpotData: FlowerSpotEntity,
    bloomingStatus: BloomStatusEntity?,
    spotCategory: SpotCategory = .trail,
    festivalInfo: FestivalInfoEntity? = nil,
    badges: [CategoryBadgeEntity] = []
  ) {
    self.flowerSpotData = flowerSpotData
    self.bloomingStatus = bloomingStatus
    self.spotCategory = spotCategory
    self.festivalInfo = festivalInfo
    self.badges = badges
  }

  public var body: some View {
    HStack(alignment: .center, spacing: .Number12) {
      VStack(alignment: .leading, spacing: .Number10) {
        titleSection
        tagSection
      }

      Spacer()

      if let firstImageUrl = flowerSpotData.images.first?.url {
        RemoteImageView(urlString: firstImageUrl)
          .frame(width: 80, height: 80)
          .clipped()
          .cornerRadius(8)
      }
    }
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number20)
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
              .size(.small)
              .foregroundStyle(blooming.gradiant)
            Text(blooming.text)
              .fontStyle(FontSet.Label.label2)
              .foregroundColor(blooming.textColor)
          }
        }
      }

      // 축제: 날짜 표시 / 그 외: 주소 표시
      if spotCategory == .festival, let festival = festivalInfo {
        Text("\(festival.startDate) ~ \(festival.endDate)")
          .fontStyle(FontSet.Body.body3)
          .foregroundColor(ColorSet.Text.Primary)
      } else {
        Text(flowerSpotData.address)
          .fontStyle(FontSet.Body.body3)
          .foregroundColor(ColorSet.Text.Primary)
      }
    }
  }

  // MARK: - Tag Section

  @ViewBuilder
  private var tagSection: some View {
    HStack(spacing: .Number4) {
      ForEach(badges, id: \.label) { badge in
        TagView(text: badge.label)
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

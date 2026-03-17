//
//  CategoryListItemView.swift
//  CategoryFeatureInterface
//
//  Created by Jiyeon
//

import SwiftUI
import DesignKit
import FlowerSpotClient

public struct CategoryListItemView: View {
  private let flowerSpot: FlowerSpotEntity
  private let onTap: (FlowerSpotEntity) -> Void

  public init(
    flowerSpot: FlowerSpotEntity,
    onTap: @escaping (FlowerSpotEntity) -> Void = { _ in }
  ) {
    self.flowerSpot = flowerSpot
    self.onTap = onTap
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: .Number0) {
      HStack(alignment: .center, spacing: .Number12) {
        contentView

        if let previewUrl = flowerSpot.previewUrl {
          RemoteImageView(urlString: previewUrl)
            .frame(width: 72, height: 72)
            .clipped()
            .cornerRadius(.Number16)
        }
      }
      .padding(.vertical, .Number12)
      BorderView(size: .long)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      onTap(flowerSpot)
    }
  }

  @ViewBuilder
  private var contentView: some View {
    HStack {
      VStack(alignment: .leading, spacing: .Number0) {
        Text(flowerSpot.streetName)
          .fontStyle(FontSet.Body.body2)
          .foregroundStyle(ColorSet.Text.Primary)
        Text(flowerSpot.address)
          .fontStyle(FontSet.Caption.caption1)
          .foregroundStyle(ColorSet.Text.Tertiary)
        HStack(spacing: .Number4) {
          if let bloomStatus = BloomStatus(rawValue: flowerSpot.bloomingStatus) {
            BloomStateTagView(state: bloomStatus)
          }
          TagView(text: flowerSpot.recentlyVisitedCountString)
        }
        .padding(.top, .Number8)
      }
      Spacer()
    }
  }
}

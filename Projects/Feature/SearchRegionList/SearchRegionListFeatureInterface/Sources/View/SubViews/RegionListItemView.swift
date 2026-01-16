//
//  RegionListItemView.swift
//  SearchRegionListFeature
//
//  Created by Jiyeon on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI
import DesignKit
import FlowerSpotClient

public struct RegionListItemView: View {
  private let flowerSpot: FlowerSpotEntity
  private let onTap: (FlowerSpotEntity) -> Void
  
  public init(flowerSpot: FlowerSpotEntity, onTap: @escaping (FlowerSpotEntity) -> Void = { _ in }) {
    self.flowerSpot = flowerSpot
    self.onTap = onTap
  }
  public var body: some View {
    VStack(spacing: .Number12) {
      HStack(alignment: .center, spacing: .Number12) {
        contentView
        
        if let firstImageUrl = flowerSpot.imageUrls.first {
          RemoteImageView(urlString: firstImageUrl)
            .frame(width: 72, height: 72)
            .clipped()
            .cornerRadius(16)
        }
      }
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(ColorSet.Border.Secondary)
    }
    .padding(.top, .Number12)
    .contentShape(Rectangle())
    .onTapGesture {
      onTap(flowerSpot)
    }
  }
  
  @ViewBuilder
  private var contentView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0) {
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
        .padding(.top, 8)
        
      }
      Spacer()
    }
  }
}

//
//  CategoryListItemView.swift
//  CategoryFeatureInterface
//
//  Created by Jiyeon
//

import SwiftUI
import DesignKit
import CategoryClient

public struct CategoryListItemView: View {
  private let type: CategoryType?
  private let item: CategoryItemEntity
  private let onTap: (CategoryItemEntity) -> Void

  public init(
    type: CategoryType?,
    item: CategoryItemEntity,
    onTap: @escaping (CategoryItemEntity) -> Void = { _ in }
  ) {
    self.type = type
    self.item = item
    self.onTap = onTap
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: .Number0) {
      HStack(alignment: .center, spacing: .Number12) {
        contentView

        if let imageURL = item.imageURL {
          RemoteImageView(urlString: imageURL)
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
      onTap(item)
    }
  }

  @ViewBuilder
  private var contentView: some View {
    HStack {
      VStack(alignment: .leading, spacing: .Number0) {
        Text(item.name)
          .fontStyle(FontSet.Body.body2)
          .foregroundStyle(ColorSet.Text.Primary)
        Text(type == .event ? (item.period ?? "") : (item.address ?? ""))
          .fontStyle(FontSet.Caption.caption1)
          .foregroundStyle(ColorSet.Text.Tertiary)
        HStack(spacing: .Number4) {
          if let bloomStatus = BloomStatus(rawValue: item.bloomingStatus) {
            BloomStateTagView(state: bloomStatus)
          }

          if type == .event {
            if let region = item.region {
              TagView(text: region.name)
            }
          } else {
            TagView(text: item.recentlyVisitedCountString)
          }
        }
        .padding(.top, .Number8)
      }
      Spacer()
    }
  }
}

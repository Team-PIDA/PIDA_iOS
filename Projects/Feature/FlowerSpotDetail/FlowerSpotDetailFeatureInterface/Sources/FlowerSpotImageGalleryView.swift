//
//  FlowerSpotImageGalleryView.swift
//
//  FlowerSpotDetail
//
//  Created by 조용인
//

import SwiftUI
import DesignKit

/// 확장 바텀시트에서 이미지를 표시하는 갤러리 뷰
/// - 0장: 표시 안함
/// - 1장: 단일 이미지 (화면 너비, 높이 160)
/// - 2장: 가로 나란히 (spacing 12)
/// - 3장+: 수평 스크롤 (160x160) + 더보기 버튼
public struct FlowerSpotImageGalleryView: View {
  private let imageUrls: [String]
  private let onImageTapped: ((Int) -> Void)?
  private let onMoreTapped: (() -> Void)?

  private let imageHeight: CGFloat = 160
  private let spacing: CGFloat = 12

  public init(
    imageUrls: [String],
    onImageTapped: ((Int) -> Void)? = nil,
    onMoreTapped: (() -> Void)? = nil
  ) {
    self.imageUrls = imageUrls
    self.onImageTapped = onImageTapped
    self.onMoreTapped = onMoreTapped
  }

  public var body: some View {
    Group {
      switch imageUrls.count {
      case 0:
        EmptyView()
      case 1:
        singleImageView
      case 2:
        twoImagesView
      default:
        multipleImagesView
      }
    }
  }

  // MARK: - Single Image (1장)

  @ViewBuilder
  private var singleImageView: some View {
    RemoteImageView(urlString: imageUrls[0]) {
      onImageTapped?(0)
    }
    .frame(height: imageHeight)
    .frame(maxWidth: .infinity)
    .clipped()
    .cornerRadius(10)
  }

  // MARK: - Two Images (2장)

  @ViewBuilder
  private var twoImagesView: some View {
    HStack(spacing: spacing) {
      ForEach(0..<2, id: \.self) { index in
        RemoteImageView(urlString: imageUrls[index]) {
          onImageTapped?(index)
        }
        .frame(height: imageHeight)
        .frame(maxWidth: .infinity)
        .clipped()
        .cornerRadius(10)
      }
    }
  }

  // MARK: - Multiple Images (3장 이상)

  @ViewBuilder
  private var multipleImagesView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: spacing) {
        ForEach(0..<imageUrls.count, id: \.self) { index in
          RemoteImageView(urlString: imageUrls[index]) {
            onImageTapped?(index)
          }
          .frame(width: imageHeight, height: imageHeight)
          .clipped()
          .cornerRadius(10)
        }

        // 더보기 버튼
        moreButton
      }
    }
  }

  // MARK: - More Button

  @ViewBuilder
  private var moreButton: some View {
    Button {
      onMoreTapped?()
    } label: {
      VStack(spacing: .Number4) {
        Icon(image: .chevronRight)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Secondary)

        Text("더보기")
          .fontStyle(FontSet.Caption.caption1)
          .foregroundColor(ColorSet.Text.Secondary)
      }
      .frame(width: 60, height: imageHeight)
      .background(ColorSet.Background.Tertiary)
      .cornerRadius(10)
    }
  }
}

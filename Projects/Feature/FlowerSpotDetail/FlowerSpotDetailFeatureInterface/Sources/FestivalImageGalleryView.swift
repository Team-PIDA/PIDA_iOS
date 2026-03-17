//
//  FestivalImageGalleryView.swift
//
//  FlowerSpotDetail
//
//  Created by 조용인
//

import SwiftUI
import DesignKit
import FlowerSpotClient

/// 축제 상세페이지 전용 이미지 갤러리
/// - 포스터 + 사진: 포스터(세로 비율) → 세로 구분선 → 일반 사진 (가로 스크롤)
/// - 포스터만: 화면 가로 너비 fill, 높이 160, 가운데 크롭
public struct FestivalImageGalleryView: View {
  private let posterImageURL: String?
  private let images: [FlowerSpotImageEntity]
  private let prefetchedImages: [String: Data]
  private let onImageTapped: ((Int) -> Void)?
  private let onMoreTapped: (() -> Void)?
  private let onImageLoaded: ((String, Data) -> Void)?

  private let imageHeight: CGFloat = 160
  private let spacing: CGFloat = 12

  /// 축제 포스터 세로 비율 (피그마 시안 기준)
  private let posterAspectRatio: CGFloat = 1684.0 / 2384.0

  public init(
    posterImageURL: String?,
    images: [FlowerSpotImageEntity],
    prefetchedImages: [String: Data] = [:],
    onImageTapped: ((Int) -> Void)? = nil,
    onMoreTapped: (() -> Void)? = nil,
    onImageLoaded: ((String, Data) -> Void)? = nil
  ) {
    self.posterImageURL = posterImageURL
    self.images = images
    self.prefetchedImages = prefetchedImages
    self.onImageTapped = onImageTapped
    self.onMoreTapped = onMoreTapped
    self.onImageLoaded = onImageLoaded
  }

  public var body: some View {
    if let posterURL = posterImageURL {
      if images.isEmpty {
        // 포스터만: 전체 너비, 높이 160, 가운데 크롭
        posterOnlyView(url: posterURL)
      } else {
        // 포스터 + 사진: 가로 스크롤
        posterWithPhotosView(posterURL: posterURL)
      }
    } else if !images.isEmpty {
      // 포스터 없이 사진만: 기존 갤러리와 동일
      FlowerSpotImageGalleryView(
        images: images,
        prefetchedImages: prefetchedImages,
        onImageTapped: onImageTapped,
        onMoreTapped: onMoreTapped,
        onImageLoaded: onImageLoaded
      )
    }
  }

  // MARK: - Poster Only

  @ViewBuilder
  private func posterOnlyView(url: String) -> some View {
    RemoteImageView(
      imageData: prefetchedImages[url],
      fallbackUrlString: url,
      onImageLoaded: { data in onImageLoaded?(url, data) }
    )
    .frame(maxWidth: .infinity)
    .frame(height: imageHeight)
    .clipped()
    .cornerRadius(8)
  }

  // MARK: - Poster + Photos

  @ViewBuilder
  private func posterWithPhotosView(posterURL: String) -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .center, spacing: spacing) {
        // 포스터 이미지 (세로 비율)
        RemoteImageView(
          imageData: prefetchedImages[posterURL],
          fallbackUrlString: posterURL,
          onImageLoaded: { data in onImageLoaded?(posterURL, data) }
        )
        .aspectRatio(posterAspectRatio, contentMode: .fit)
        .frame(height: imageHeight)
        .clipped()
        .cornerRadius(8)

        // 세로 구분선
        Rectangle()
          .fill(ColorSet.Border.Secondary)
          .frame(width: 1, height: imageHeight)

        // 일반 사진들 (최대 3장)
        ForEach(0..<min(3, images.count), id: \.self) { index in
          let image = images[index]
          ZStack(alignment: .bottomTrailing) {
            RemoteImageView(
              imageData: prefetchedImages[image.url],
              fallbackUrlString: image.url,
              onTap: { onImageTapped?(index) },
              onImageLoaded: { data in onImageLoaded?(image.url, data) }
            )
            .frame(width: imageHeight, height: imageHeight)
            .clipped()

            if let dateText = image.createdAt?.photoDateText() {
              VStack {
                Spacer()
                HStack {
                  Spacer()
                  Text(dateText)
                    .fontStyle(FontSet.Caption.caption1)
                    .foregroundColor(ColorSet.Text.Inverse)
                }
                .padding(.vertical, .Number8)
                .padding(.horizontal, .Number12)
                .background(
                  LinearGradient(
                    gradient: Gradient(colors: [
                      Color(hex: 0x121212).opacity(0),
                      Color(hex: 0x121212).opacity(0.4)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                  )
                )
              }
            }
          }
          .cornerRadius(8)
        }

        // 더보기 버튼 (축제는 포스터 + 사진 구성이므로 2장 이상부터 표시)
        if images.count >= 2 {
          moreButton
        }
      }
    }
  }

  // MARK: - More Button

  @ViewBuilder
  private var moreButton: some View {
    VStack(spacing: 10) {
      Spacer()

      Button {
        onMoreTapped?()
      } label: {
        Icon(image: .chevronRight)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Secondary)
          .frame(width: 48, height: 48)
          .background(ColorSet.Background.Primary)
          .clipShape(Circle())
          .overlay(
            Circle()
              .stroke(ColorSet.Border.Secondary, lineWidth: 1)
          )
      }

      Text("더보기")
        .fontStyle(FontSet.Caption.caption1)
        .foregroundColor(ColorSet.Text.Secondary)

      Spacer()
    }
    .frame(width: 80)
  }
}

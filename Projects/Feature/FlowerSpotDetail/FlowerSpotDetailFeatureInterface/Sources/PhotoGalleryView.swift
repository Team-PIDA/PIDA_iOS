//
//  PhotoGalleryView.swift
//
//  FlowerSpotDetail
//
//  Created by 조용인
//

import SwiftUI
import DesignKit
import FlowerSpotClient
import Shared

/// 이미지 갤러리 화면 (2열 그리드)
public struct PhotoGalleryView: View {
  private let images: [FlowerSpotImageEntity]
  private let prefetchedImages: [String: Data]
  private let title: String
  private let onImageTapped: ((Int) -> Void)?
  private let onBackTapped: (() -> Void)?
  private let onImageLoaded: ((String, Data) -> Void)?

  private let columns = [
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible(), spacing: 12)
  ]

  public init(
    images: [FlowerSpotImageEntity],
    prefetchedImages: [String: Data] = [:],
    title: String,
    onImageTapped: ((Int) -> Void)? = nil,
    onBackTapped: (() -> Void)? = nil,
    onImageLoaded: ((String, Data) -> Void)? = nil
  ) {
    self.images = images
    self.prefetchedImages = prefetchedImages
    self.title = title
    self.onImageTapped = onImageTapped
    self.onBackTapped = onBackTapped
    self.onImageLoaded = onImageLoaded
  }

  public var body: some View {
    VStack(spacing: .Number0) {
      navigationBar
      gridContent
    }
    .background(ColorSet.Background.Primary)
    .navigationBarBackButtonHidden(true)
  }

  // MARK: - Navigation Bar

  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .back)
          .size(.superLarge)
          .action {
            onBackTapped?()
          }
          .color(ColorSet.Icon.Primary)
      },
      title: title
    )
  }

  // MARK: - Grid Content

  @ViewBuilder
  private var gridContent: some View {
    GeometryReader { geometry in
      let itemWidth = (geometry.size.width - 16 * 2 - 12) / 2
      ScrollView {
        LazyVGrid(columns: columns, spacing: 12) {
          ForEach(Array(images.enumerated()), id: \.offset) { index, image in
            ZStack(alignment: .bottomTrailing) {
              RemoteImageView(
                imageData: prefetchedImages[image.url],
                fallbackUrlString: image.url,
                onTap: { onImageTapped?(index) },
                onImageLoaded: { data in onImageLoaded?(image.url, data) }
              )
              .frame(width: itemWidth, height: itemWidth)
              .clipped()

              if let dateText = image.createdAt?.photoDateText() {
                // 하단 그라디언트 오버레이 + 텍스트
                VStack {
                  Spacer()
                  HStack {
                    Spacer()
                    Text(dateText)
                      .fontStyle(FontSet.Caption.caption1)
                      .foregroundColor(ColorSet.Text.Inverse)
                  }
                  .padding(.top, .Number8)
                  .padding(.bottom, .Number8)
                  .padding(.leading, .Number12)
                  .padding(.trailing, .Number12)
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
            .cornerRadius(16)
          }
        }
        .padding(.horizontal, .Number16)
        .padding(.top, .Number12)
      }
    }
  }
}

// MARK: - Preview

#Preview {
  let calendar = Calendar.current
  let now = Date()

  // 더미 이미지 데이터 (다양한 날짜)
  let dummyImages: [FlowerSpotImageEntity] = [
    // 당일 (표시 안 함)
    FlowerSpotImageEntity(
      url: "https://picsum.photos/400/400?random=1",
      createdAt: now
    ),
    // 3일 전
    FlowerSpotImageEntity(
      url: "https://picsum.photos/400/400?random=2",
      createdAt: calendar.date(byAdding: .day, value: -3, to: now)
    ),
    // 7일 전
    FlowerSpotImageEntity(
      url: "https://picsum.photos/400/400?random=3",
      createdAt: calendar.date(byAdding: .day, value: -7, to: now)
    ),
    // 15일 전 (같은 해 → "M월 D일")
    FlowerSpotImageEntity(
      url: "https://picsum.photos/400/400?random=4",
      createdAt: calendar.date(byAdding: .day, value: -15, to: now)
    ),
    // 작년 (다른 해 → "YYYY년 M월 D일")
    FlowerSpotImageEntity(
      url: "https://picsum.photos/400/400?random=5",
      createdAt: calendar.date(byAdding: .year, value: -1, to: now)
    ),
    // 날짜 없음 (표시 안 함)
    FlowerSpotImageEntity(
      url: "https://picsum.photos/400/400?random=6",
      createdAt: nil
    )
  ]

  return PhotoGalleryView(
    images: dummyImages,
    title: "여의도 윤중로"
  )
}

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
          ForEach(0..<images.count, id: \.self) { index in
            let image = images[index]
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
                Text(dateText)
                  .fontStyle(FontSet.Caption.caption1)
                  .foregroundColor(ColorSet.Text.Inverse)
                  .padding(.trailing, .Number12)
                  .padding(.bottom, .Number4)
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

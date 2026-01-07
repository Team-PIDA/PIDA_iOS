//
//  PhotoGalleryView.swift
//
//  FlowerSpotDetail
//
//  Created by 조용인
//

import SwiftUI
import DesignKit

/// 이미지 갤러리 화면 (2열 그리드)
public struct PhotoGalleryView: View {
  private let imageUrls: [String]
  private let title: String
  private let onImageTapped: ((Int) -> Void)?
  private let onBackTapped: (() -> Void)?

  private let columns = [
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible(), spacing: 12)
  ]

  public init(
    imageUrls: [String],
    title: String,
    onImageTapped: ((Int) -> Void)? = nil,
    onBackTapped: (() -> Void)? = nil
  ) {
    self.imageUrls = imageUrls
    self.title = title
    self.onImageTapped = onImageTapped
    self.onBackTapped = onBackTapped
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
          ForEach(0..<imageUrls.count, id: \.self) { index in
            RemoteImageView(urlString: imageUrls[index]) {
              onImageTapped?(index)
            }
            .frame(width: itemWidth, height: itemWidth)
            .clipped()
            .cornerRadius(16)
          }
        }
        .padding(.horizontal, .Number16)
        .padding(.top, .Number12)
      }
    }
  }
}

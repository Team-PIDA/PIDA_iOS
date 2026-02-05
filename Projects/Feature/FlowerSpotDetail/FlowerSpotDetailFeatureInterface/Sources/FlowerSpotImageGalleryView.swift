//
//  FlowerSpotImageGalleryView.swift
//
//  FlowerSpotDetail
//
//  Created by 조용인
//

import SwiftUI
import DesignKit
import FlowerSpotClient

/// 확장 바텀시트에서 이미지를 표시하는 갤러리 뷰
/// - 0장: 표시 안함
/// - 1장: 단일 이미지 (화면 너비, 높이 160)
/// - 2장: 가로 나란히 (spacing 12)
/// - 3장+: 수평 스크롤 (160x160) + 더보기 버튼
public struct FlowerSpotImageGalleryView: View {
  private let images: [FlowerSpotImageEntity]
  private let prefetchedImages: [String: Data]
  private let onImageTapped: ((Int) -> Void)?
  private let onMoreTapped: (() -> Void)?
  private let onImageLoaded: ((String, Data) -> Void)?

  private let imageHeight: CGFloat = 160
  private let spacing: CGFloat = 12

  public init(
    images: [FlowerSpotImageEntity],
    prefetchedImages: [String: Data] = [:],
    onImageTapped: ((Int) -> Void)? = nil,
    onMoreTapped: (() -> Void)? = nil,
    onImageLoaded: ((String, Data) -> Void)? = nil
  ) {
    self.images = images
    self.prefetchedImages = prefetchedImages
    self.onImageTapped = onImageTapped
    self.onMoreTapped = onMoreTapped
    self.onImageLoaded = onImageLoaded
  }

  public var body: some View {
    Group {
      switch images.count {
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
    let image = images[0]
    ZStack(alignment: .bottomTrailing) {
      RemoteImageView(
        imageData: prefetchedImages[image.url],
        fallbackUrlString: image.url,
        onTap: { onImageTapped?(0) },
        onImageLoaded: { data in onImageLoaded?(image.url, data) }
      )
      .frame(height: imageHeight)
      .frame(maxWidth: .infinity)
      .clipped()
      .cornerRadius(10)
      
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
  }

  // MARK: - Two Images (2장)

  @ViewBuilder
  private var twoImagesView: some View {
    GeometryReader { geometry in
      let imageWidth = (geometry.size.width - spacing) / 2
      HStack(spacing: spacing) {
        ForEach(0..<2, id: \.self) { index in
          let image = images[index]
          ZStack(alignment: .bottomTrailing) {
          RemoteImageView(
            imageData: prefetchedImages[image.url],
            fallbackUrlString: image.url,
            onTap: { onImageTapped?(index) },
            onImageLoaded: { data in onImageLoaded?(image.url, data) }
          )
          .frame(width: imageWidth, height: imageHeight)
          .clipped()
          .cornerRadius(10)
          
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
        }
      }
    }
    .frame(height: imageHeight)
  }

  // MARK: - Multiple Images (3장 이상)

  @ViewBuilder
  private var multipleImagesView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: spacing) {
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
            .cornerRadius(10)
            
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
        }

        // 더보기 버튼
        moreButton
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

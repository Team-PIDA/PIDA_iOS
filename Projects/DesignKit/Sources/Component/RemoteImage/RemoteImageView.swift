//
//  RemoteImageView.swift
//  DesignKit
//
//  Created by 조용인 on 1/7/26.
//  Copyright © 2026 com.yongin.pida. All rights reserved.
//

import SwiftUI

/// 원격 URL에서 이미지를 로드하여 표시하는 뷰
/// - 로딩 중: 플레이스홀더 표시
/// - 실패 시: 에러 플레이스홀더 표시
/// - 성공 시: 이미지를 fill 모드로 표시 (가운데 크롭)
public struct RemoteImageView: View {
  private let imageData: Data?
  private let fallbackUrl: URL?
  private let fallbackUrlString: String?
  private let onTap: (() -> Void)?
  private let onImageLoaded: ((Data) -> Void)?
  private var placeholderStyle: ImagePlaceholderView.Style = .light

  /// Data 기반 초기화 (프리페치된 이미지 사용)
  /// - Parameters:
  ///   - imageData: 프리페치된 이미지 Data (nil이면 fallbackUrl 사용)
  ///   - fallbackUrl: Data가 없을 때 사용할 URL
  ///   - onTap: 탭 콜백
  ///   - onImageLoaded: 이미지 로드 완료 시 Data 전달 (캐싱용)
  public init(
    imageData: Data?,
    fallbackUrl: URL? = nil,
    onTap: (() -> Void)? = nil,
    onImageLoaded: ((Data) -> Void)? = nil
  ) {
    self.imageData = imageData
    self.fallbackUrl = fallbackUrl
    self.fallbackUrlString = fallbackUrl?.absoluteString
    self.onTap = onTap
    self.onImageLoaded = onImageLoaded
  }

  /// Data 기반 초기화 (문자열 URL)
  public init(
    imageData: Data?,
    fallbackUrlString: String?,
    onTap: (() -> Void)? = nil,
    onImageLoaded: ((Data) -> Void)? = nil
  ) {
    self.imageData = imageData
    self.fallbackUrl = fallbackUrlString.flatMap { URL(string: $0) }
    self.fallbackUrlString = fallbackUrlString
    self.onTap = onTap
    self.onImageLoaded = onImageLoaded
  }

  /// URL 기반 초기화 (기존 호환성 유지)
  public init(
    url: URL?,
    onTap: (() -> Void)? = nil,
    onImageLoaded: ((Data) -> Void)? = nil
  ) {
    self.imageData = nil
    self.fallbackUrl = url
    self.fallbackUrlString = url?.absoluteString
    self.onTap = onTap
    self.onImageLoaded = onImageLoaded
  }

  /// URL 문자열 기반 초기화 (기존 호환성 유지)
  public init(
    urlString: String,
    onTap: (() -> Void)? = nil,
    onImageLoaded: ((Data) -> Void)? = nil
  ) {
    self.imageData = nil
    self.fallbackUrl = URL(string: urlString)
    self.fallbackUrlString = urlString
    self.onTap = onTap
    self.onImageLoaded = onImageLoaded
  }

  public var body: some View {
    Group {
      if let data = imageData, let uiImage = UIImage(data: data) {
        // 프리페치된 Data가 있으면 즉시 표시
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(contentMode: .fill)
      } else if onImageLoaded != nil {
        // 캐싱 콜백이 있으면 커스텀 로더 사용
        CachingImageLoader(
          url: fallbackUrl,
          placeholderStyle: placeholderStyle,
          onImageLoaded: onImageLoaded
        )
      } else {
        // 캐싱 불필요하면 기존 AsyncImage 사용
        AsyncImage(url: fallbackUrl) { phase in
          switch phase {
          case .empty:
            ImagePlaceholderView(state: .loading)
              .style(placeholderStyle)
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
          case .failure:
            ImagePlaceholderView(state: .failure)
              .style(placeholderStyle)
          @unknown default:
            ImagePlaceholderView(state: .loading)
              .style(placeholderStyle)
          }
        }
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      onTap?()
    }
  }

  // MARK: - Style Modifier

  public func placeholderStyle(_ style: ImagePlaceholderView.Style) -> Self {
    var copy = self
    copy.placeholderStyle = style
    return copy
  }
}

// MARK: - Caching Image Loader

/// 이미지 로드 후 Data를 콜백으로 전달하는 커스텀 로더
private struct CachingImageLoader: View {
  let url: URL?
  let placeholderStyle: ImagePlaceholderView.Style
  let onImageLoaded: ((Data) -> Void)?

  @State private var loadedImage: UIImage?
  @State private var isLoading = true
  @State private var loadFailed = false

  var body: some View {
    Group {
      if let image = loadedImage {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fill)
      } else if loadFailed {
        ImagePlaceholderView(state: .failure)
          .style(placeholderStyle)
      } else {
        ImagePlaceholderView(state: .loading)
          .style(placeholderStyle)
      }
    }
    .task(id: url) {
      await loadImage()
    }
  }

  private func loadImage() async {
    guard let url else {
      loadFailed = true
      isLoading = false
      return
    }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      if let image = UIImage(data: data) {
        await MainActor.run {
          loadedImage = image
          isLoading = false
          onImageLoaded?(data)
        }
      } else {
        await MainActor.run {
          loadFailed = true
          isLoading = false
        }
      }
    } catch {
      await MainActor.run {
        loadFailed = true
        isLoading = false
      }
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    // 성공 케이스 (실제 이미지 URL)
    RemoteImageView(urlString: "https://picsum.photos/200")
      .frame(width: 160, height: 160)
      .clipped()
      .cornerRadius(16)

    // 실패 케이스 (잘못된 URL)
    RemoteImageView(urlString: "invalid-url")
      .frame(width: 80, height: 80)
      .clipped()
      .cornerRadius(16)
  }
}

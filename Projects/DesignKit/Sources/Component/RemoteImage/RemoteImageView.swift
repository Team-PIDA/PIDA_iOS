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
  private let url: URL?
  private let onTap: (() -> Void)?

  public init(
    url: URL?,
    onTap: (() -> Void)? = nil
  ) {
    self.url = url
    self.onTap = onTap
  }

  public init(
    urlString: String,
    onTap: (() -> Void)? = nil
  ) {
    self.url = URL(string: urlString)
    self.onTap = onTap
  }

  public var body: some View {
    AsyncImage(url: url) { phase in
      switch phase {
      case .empty:
        ImagePlaceholderView(state: .loading)
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
      case .failure:
        ImagePlaceholderView(state: .failure)
      @unknown default:
        ImagePlaceholderView(state: .loading)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      onTap?()
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

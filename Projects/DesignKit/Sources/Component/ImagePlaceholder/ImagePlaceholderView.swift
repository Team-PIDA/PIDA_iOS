//
//  ImagePlaceholderView.swift
//  DesignKit
//
//  Created by Claude on 1/7/26.
//  Copyright © 2026 com.yongin.pida. All rights reserved.
//

import SwiftUI

/// 이미지 로딩 중 또는 로딩 실패 시 표시할 플레이스홀더 뷰
public struct ImagePlaceholderView: View {
  public enum State {
    case loading
    case failure
  }

  private let state: State

  public init(state: State = .loading) {
    self.state = state
  }

  public var body: some View {
    ZStack {
      ColorSet.Background.Tertiary

      switch state {
      case .loading:
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: ColorSet.Gray._300))
      case .failure:
        Icon(image: .placeholder)
          .size(.superLarge)
          .foregroundColor(ColorSet.Icon.Secondary)
      }
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    ImagePlaceholderView(state: .loading)
      .frame(width: 160, height: 160)
      .cornerRadius(16)

    ImagePlaceholderView(state: .failure)
      .frame(width: 160, height: 160)
      .cornerRadius(16)
  }
}

//
//  BottomSheet.swift
//  DesignKit
//
//  Created by 조용인 on 3/31/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct CherryBlossomBottomSheet: View {
  public var title: String
  public var description: String
  public var tags: [String]
  public var blossomState: BloomStatus
  public var onPullUp: (() async -> Void)?
  public var isLoading: Bool
  
  @GestureState private var dragOffset: CGFloat = .Number0
  
  public init(
    title: String,
    description: String,
    tags: [String],
    blossomState: BloomStatus,
    onPullUp: (() -> Void)? = nil,
    isLoading: Bool = false
  ) {
    self.title = title
    self.description = description
    self.tags = tags
    self.blossomState = blossomState
    self.onPullUp = onPullUp
    self.isLoading = isLoading
  }
  
  public var body: some View {
    content
      .gesture(
        DragGesture(minimumDistance: 20)
          .updating($dragOffset) { value, state, _ in
            state = value.translation.height
          }
          .onEnded { value in
            if value.translation.height < -80 {
              Task { @MainActor in await onPullUp?() }
            }
          }
      )
  }
  
  private var content: some View {
    VStack(alignment: .leading, spacing: .Number0) {
      homeIndicator
      
      if isLoading {
        loadingView
      } else {
        mainInfoView
      }
      safeArea
    }
    .background(ColorSet.Background.Primary)
    .cornerRadius(.Number20, corners: [.topLeft, .topRight])
  }
  
  @ViewBuilder
  private var homeIndicator: some View {
    Rectangle()
      .frame(width: .Number80, height: .Number4)
      .cornerRadius(.Number2)
      .foregroundColor(ColorSet.Gray._200)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.top, .Number12)
  }
  
  @ViewBuilder
  private var mainInfoView: some View {
    VStack(alignment: .leading, spacing: .Number8) {
      VStack(alignment: .leading, spacing: .Number2) {
        HStack(spacing: .Number8) {
          Text(title)
            .fontStyle(FontSet.Heading.heading2)
            .foregroundColor(ColorSet.Text.Primary)
          
          HStack(spacing: 4) {
            GradiantIcon(image: .flower)
              .size(.large)
              .foregroundStyle(blossomState.gradiant)
            Text(blossomState.text)
              .fontStyle(FontSet.Label.label2)
              .foregroundColor(blossomState.textColor)
          }
        }
        
        Text(description)
          .fontStyle(FontSet.Body.body3)
          .foregroundColor(ColorSet.Text.Primary)
      }
      
      HStack(spacing: .Number4) {
        ForEach(tags, id: \.self) { tag in
          TagView(text: tag)
        }
      }
    }
    .padding(.horizontal, .Number16)
    .padding(.top, .Number20)
  }
  
  @ViewBuilder
  private var loadingView: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: ColorSet.Gray._300))
        Spacer()
      }
      Spacer()
    }
  }
  
  @ViewBuilder
  private var safeArea: some View {
    GeometryReader { geometry in
      Rectangle()
        .fill(ColorSet.Background.Primary)
        .frame(height: max(geometry.safeAreaInsets.bottom, 0))
        .ignoresSafeArea()
    }
  }
}


//#Preview {
//  ZStack {
//    Color.white
//
//    VStack {
//      Spacer() // 상단 여백 확보
//      CherryBlossomBottomSheet(
//        title: "석촌호수길",
//        description: "서울 송파구 송파나루길 256 문화공간 호수",
//        tags: ["잠실동", "50m이내", "최근 방문 0회"],
//        blossomState: "만개예요!"
//      )
//    }
//  }
//}

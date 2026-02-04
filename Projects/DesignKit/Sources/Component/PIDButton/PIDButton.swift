//
//  PIDButton.swift
//  DesignKit
//
//  Created by 조용인 on 3/15/25.
//  Copyright 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DotLottie

public struct PIDButton<IconContent: View>: View {

  public var title: String
  public var size: PIDButtonSize
  public var isDisabled: Bool = false
  public var isError: Bool = false
  public var isSecondary: Bool = false
  public var isLoading: Bool = false
  public var action: (() async -> Void)? = nil
  public var iconContent: (() -> IconContent)?

  public var backgroundColor: Color = ColorSet.Component.Primary
  public var textColor: Color? = nil
  public var isFullWidth: Bool = true

  @State private var isPressed: Bool = false
  
  public init(
    title: String,
    size: PIDButtonSize = .large,
    @ViewBuilder iconContent: @escaping () -> IconContent
  ) {
    self.title = title
    self.size = size
    self.iconContent = iconContent
  }
  
  public init(
    title: String,
    size: PIDButtonSize
  ) where IconContent == EmptyView {
    self.title = title
    self.size = size
    self.iconContent = nil
  }
  
  public var body: some View {
    content
      .buttonPress(
        isPressed: $isPressed,
        isDisabled: isDisabled || isLoading,
        action: action
      )
  }

  @ViewBuilder
  private var content: some View {
    HStack(spacing: .Number6) {
      if isLoading {
        DotLottieAnimation(
          fileName: LottieSet.dot_loading.name,
          bundle: DesignKitResources.bundle,
          config: AnimationConfig(autoplay: true, loop: true)
        )
        .view()
        .frame(height: size.loadingSize)
      } else {
        iconContent.map { $0() }
        Text(title)
          .foregroundColor(resolvedTextColor)
          .fontStyle(size.font)
      }
    }
    .frame(maxWidth: isFullWidth ? .infinity : nil)
    .padding(.horizontal, isLoading ? .Number0 : (isFullWidth ? .Number0 : size.padding.horizonal))
    .padding(.vertical, isLoading ? .Number0 : size.padding.vertical)
    .background(
      RoundedRectangle(cornerRadius: size.cornerRadius)
        .fill( isLoading ? ColorSet.Component.Disabled : backgroundColor)
    )
    .overlay(
      RoundedRectangle(cornerRadius: size.cornerRadius)
        .inset(by: 0.5)
        .stroke(
          isSecondary || isLoading
          ? ColorSet.Border.Secondary
          : backgroundColor,
          lineWidth: 1
        )
    )
    .overlay {
      if isPressed {
        RoundedRectangle(cornerRadius: size.cornerRadius)
          .fill(ColorSet.Component.Pressed)
      }
    }
  }

  private var resolvedTextColor: Color {
    if let textColor {
      return textColor
    }
    if isDisabled {
      return ColorSet.Text.Disabled
    }
    return isSecondary ? ColorSet.Text.Primary : ColorSet.Text.Inverse
  }
}

#Preview {
  List {
    Section("일반 텍스트 버튼") {
      PIDButton(
        title: "Label",
        size: .large
      )
      .border(Color.red)
      
      PIDButton(
        title: "Label",
        size: .medium
      )
      .border(Color.red)
      
      PIDButton(
        title: "Label",
        size: .small
      )
      .border(Color.red)
      
      PIDButton(
        title: "Action",
        size: .small
      )
      .action {
        print("Button Clicked")
      }
      .border(Color.red)
    }
    
    Section("아이콘 버튼") {
      PIDButton(
        title: "Label",
        size: .large
      ) {
        Icon(image: .flower)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .border(Color.red)
      
      PIDButton(
        title: "Label",
        size: .medium
      ) {
        Icon(image: .flower)
          .size(.medium)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .border(Color.red)
      
      PIDButton(
        title: "Label",
        size: .small
      ) {
        Icon(image: .flower)
          .size(.small)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .border(Color.red)
      
      PIDButton(
        title: "Label",
        size: .small
      ) {
        Icon(image: .flower)
          .size(.small)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .action {
        print("Button Clicked")
      }
      .border(Color.red)
    }
    
    Section("비활성화 버튼") {
      PIDButton(
        title: "Label",
        size: .large
      )
      .isDisabled(true)
      .border(Color.red)
      
      PIDButton(
        title: "Label",
        size: .large
      ) {
        Icon(image: .flower)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .isDisabled(true)
      .border(Color.red)
    }
    
    Section("에러 버튼") {
      PIDButton(
        title: "Label",
        size: .large
      )
      .isError(true)
      .border(Color.red)
      
      PIDButton(
        title: "Label",
        size: .large
      )  {
        Icon(image: .flower)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .isError(true)
      .border(Color.red)
    }
    
    Section("보조 버튼") {
      PIDButton(
        title: "Label",
        size: .large
      )
      .isSecondary(true)

      PIDButton(
        title: "Icon",
        size: .large
      )  {
        Icon(image: .flower)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Accent)
      }
      .isSecondary(true)

      PIDButton(
        title: "Disabled",
        size: .large
      )  {
        Icon(image: .flower)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Accent)
      }
      .isDisabled(true)
    }

    Section("로딩 버튼") {
      PIDButton(
        title: "Label",
        size: .large
      )
      .isLoading(true)

      PIDButton(
        title: "Label",
        size: .medium
      )
      .isLoading(true)

      PIDButton(
        title: "Label",
        size: .small
      )
      .isLoading(true)
    }
  }
}

//
//  PIDButton.swift
//  DesignKit
//
//  Created by 조용인 on 3/15/25.
//  Copyright 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct PIDButton<IconContent: View>: View {
  
  public var title: String
  public var size: PIDButtonSize
  public var isDisabled: Bool = false
  public var isError: Bool = false
  public var isSecondary: Bool = false
  public var action: (() async -> Void)? = nil
  public var iconContent: (() -> IconContent)?
  
  public var backgroundColor: Color {
    if isDisabled {
      return ColorSet.Component.Disabled
    } else if isError {
      return ColorSet.Component.Error
    } else if isSecondary {
      return ColorSet.Background.Primary
    } else {
      return ColorSet.Component.Primary
    }
  }
  
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
      .gesture(
        DragGesture(minimumDistance: .Number0)
          .onChanged { _ in isPressed = true }
          .onEnded {
            _ in
            isPressed = false
            if let action = action {
              Task { @MainActor in
                await action()
              }
            }
          }
      )
      .disabled(isDisabled)
  }
  
  @ViewBuilder
  private var content: some View {
    HStack(spacing: .Number6) {
      iconContent.map { $0() }
      Text(title)
        .foregroundColor(
          isDisabled
          ? ColorSet.Text.Disabled
          : isSecondary ? ColorSet.Text.Primary : ColorSet.Text.Inverse
        )
        .font(size.font)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, size.padding.vertical)
    .background(
      RoundedRectangle(cornerRadius: size.cornerRadius)
        .fill(backgroundColor)
    )
    .overlay(
      RoundedRectangle(cornerRadius: size.cornerRadius)
        .inset(by: 0.5)
        .stroke(
          isSecondary
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
  }
}

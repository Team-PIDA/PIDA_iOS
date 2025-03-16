//
//  PIDButton.swift
//  DesignKit
//
//  Created by 조용인 on 3/15/25.
//  Copyright 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct PIDButton<IconContent: View>: View {
  
  public var title: String = ""
  public var size: PIDButtonSize = .large
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
    @ViewBuilder iconContent: @escaping () -> IconContent
  ) {
    self.iconContent = iconContent
  }
  
  public init() where IconContent == EmptyView {
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
      PIDButton()
      .title("Label")
      .size(.large)
      .border(Color.red)
      
      PIDButton()
      .title("Label")
      .size(.medium)
      .border(Color.red)
      
      PIDButton()
      .title("Label")
      .size(.small)
      .border(Color.red)
      
      PIDButton()
      .title("Action")
      .size(.small)
      .action {
        print("Button Clicked")
      }
      .border(Color.red)
    }
    
    Section("아이콘 버튼") {
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.large)
      .border(Color.red)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.medium)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.medium)
      .border(Color.red)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.small)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.small)
      .border(Color.red)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.small)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Action")
      .size(.small)
      .action {
        print("Button Clicked")
      }
      .border(Color.red)
    }
    
    Section("비활성화 버튼") {
      PIDButton()
      .title("Label")
      .size(.large)
      .isDisabled(true)
      .border(Color.red)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.large)
      .isDisabled(true)
      .border(Color.red)
    }
    
    Section("에러 버튼") {
      PIDButton()
      .title("Label")
      .size(.large)
      .isError(true)
      .border(Color.red)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.large)
      .isError(true)
      .border(Color.red)
    }
    
    Section("보조 버튼") {
      PIDButton()
        .title("Label")
        .size(.large)
        .isSecondary(true)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Accent)
      }
      .title("Icon")
      .size(.large)
      .isSecondary(true)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Accent)
      }
      .title("Disabled")
      .isDisabled(true)
    }
  }
}

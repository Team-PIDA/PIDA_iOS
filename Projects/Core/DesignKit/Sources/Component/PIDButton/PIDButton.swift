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
  public var action: () -> Void = {}
  public var iconContent: (() -> IconContent)?
  
  public var backgroundColor: Color {
    if isDisabled {
      return ColorSet.Component.Disabled
    } else if isError {
      return ColorSet.Component.Error
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
        DragGesture(minimumDistance: 0)
          .onChanged { _ in isPressed = true }
          .onEnded {
            _ in
            isPressed = false
            action()
          }
      )
      .disabled(isDisabled)
  }
  
  @ViewBuilder
  private var content: some View {
    RoundedRectangle(cornerRadius: size.cornerRadius)
      .fill(backgroundColor)
      .overlay {
        HStack(spacing: 6) {
          iconContent.map { $0() }
          Text(title)
            .foregroundColor(
              isDisabled ? ColorSet.Text.Disabled : ColorSet.Text.Inverse
            )
            .font(size.font)
        }
        .padding(.vertical, size.padding.vertical)
        .padding(.horizontal, size.padding.horizonal)
      }
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
      
      PIDButton()
      .title("Label")
      .size(.medium)
      
      PIDButton()
      .title("Label")
      .size(.small)
      
      PIDButton()
      .title("Action")
      .size(.small)
      .action {
        print("Button Clicked")
      }
    }
    
    Section("아이콘 버튼") {
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.large)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.medium)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.medium)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.small)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.small)
      
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
    }
    
    Section("비활성화 버튼") {
      PIDButton()
      .title("Label")
      .size(.large)
      .isDisabled(true)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.large)
      .isDisabled(true)
    }
    
    Section("에러 버튼") {
      PIDButton()
      .title("Label")
      .size(.large)
      .isError(true)
      
      PIDButton {
        Icon(icon: IconSet.flower.swiftUIImage)
          .size(.large)
          .foregroundColor(ColorSet.Icon.Inverse)
      }
      .title("Label")
      .size(.large)
      .isError(true)
    }
  }
}

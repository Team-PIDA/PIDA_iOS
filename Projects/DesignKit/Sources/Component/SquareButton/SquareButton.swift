//
//  SquareButton.swift
//  DesignKit
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct SquareButton<IconContent: View>: View {
  
  @Binding public var isSelected: Bool
  public var title: String = ""
  private let iconView: (() -> IconContent)
  public var action: (() async -> Void)? = nil
  
  @State private var isPressed: Bool = false
  
  public init(
    title: String,
    isSelected: Binding<Bool>,
    @ViewBuilder iconView: @escaping() -> IconContent
  ) {
    self.title = title
    self._isSelected = isSelected
    self.iconView = iconView
  }
  
  public var body: some View {
    buttonContent
      .gesture(
        DragGesture(minimumDistance: .Number0)
          .onChanged { _ in isPressed = true }
          .onEnded {
            _ in
            isPressed = false
            isSelected.toggle()
            if let action = action {
              Task { @MainActor in
                await action()
              }
            }
          }
      )
  }
  
  @ViewBuilder
  private var buttonContent: some View {
    VStack(spacing: .Number8) {
      iconView()
      Text(title)
        .fontStyle(FontSet.Label.label2)
        .foregroundStyle(ColorSet.Text.Primary)
        .frame(alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      RoundedRectangle(cornerRadius: .Number10)
        .inset(by: 0.5)
        .fill(
          isSelected ?  ColorSet.Background.Accent : ColorSet.Background.Primary
        )
        .stroke(ColorSet.Border.Secondary, lineWidth: 1)
    )
    .overlay {
      if isPressed {
        RoundedRectangle(cornerRadius: .Number10)
          .fill(ColorSet.Component.Pressed)
      }
    }
  }
  
  
}

#Preview {
  SquareButton(
    title: "만개에요",
    isSelected: .constant(true)
  ) {
    Image(asset: ImageSet.avatar.swiftUIImage)
      .resizable()
      .frame(width: 40, height: 40)
  }
  .frame(width: .Number100, height: .Number100)
}


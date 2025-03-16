//
//  PIDIconButton.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct PIDIconButton<IconContent: View>: View {
  
  public var action: (() async -> Void)? = nil
  public var iconContent: (() -> IconContent)
  
  @State private var isPressed: Bool = false
  
  public init(
    @ViewBuilder iconContent: @escaping () -> IconContent
  ) {
    self.iconContent = iconContent
  }
  
  public var body: some View {
    content
      .gesture(
        DragGesture(minimumDistance: 0)
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
  }
  
  @ViewBuilder
  private var content: some View {
    Circle()
      .fill(ColorSet.Background.Primary)
      .overlay {
        iconContent()
      }
      .padding(12)
      .overlay {
        if isPressed {
          Circle()
            .fill(ColorSet.Component.Pressed)
        }
      }
      .frame(width: 48, height: 48)
  }
}

#Preview {
  HStack {
    PIDIconButton {
      Icon(icon: IconSet.flower.swiftUIImage)
        .foregroundColor(ColorSet.Icon.Accent)
    }
    .action {
      print("Button tapped")
    }
    .elevation(
      cornerRadius: 24
    )
    
    PIDIconButton {
      Icon(icon: IconSet.flower.swiftUIImage)
        .foregroundColor(ColorSet.Icon.Accent)
    }
    .elevation(
      cornerRadius: 24
    )
  }
}


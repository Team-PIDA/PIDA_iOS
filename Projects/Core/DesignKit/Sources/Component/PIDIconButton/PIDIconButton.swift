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
      .frame(width: .Number48, height: .Number48)
  }
}

#Preview {
  HStack {
    PIDIconButton {
      Icon(image: .flower)
        .foregroundColor(ColorSet.Icon.Accent)
    }
    .action {
      print("Button tapped")
    }
    .elevation(
      cornerRadius: .Number24
    )
    .border(Color.red)
    
    PIDIconButton {
      Icon(image: .flower)
        .foregroundColor(ColorSet.Icon.Accent)
    }
    .elevation(
      cornerRadius: .Number24
    )
    .border(Color.red)
  }
}


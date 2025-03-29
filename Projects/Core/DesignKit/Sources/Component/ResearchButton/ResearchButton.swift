//
//  ResearchButton.swift
//  DesignKit
//
//  Created by Jiyeon on 3/23/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct ResearchButton: View {
  
  private var action: (() async -> Void)? = nil
  @State private var isPressed: Bool = false
  
  public init(action: (() async -> Void)?) {
    self.action = action
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
    HStack(spacing: .Number4) {
      Icon(image: .replay)
        .foregroundColor(ColorSet.Text.Accent)
        .frame(width: .Number16, height: .Number16)
      Text("현 위치에서 재검색")
        .foregroundColor(ColorSet.Text.Accent)
    }
    .background(
      RoundedRectangle(cornerRadius: .Number100)
        .fill(ColorSet.Background.Primary)
    )
    .padding(.vertical, .Number6)
    .padding(.leading, .Number12)
    .padding(.trailing, .Number16)
    .frame(height: .Number33)
    .elevation(cornerRadius: .Number100)
    .overlay {
      if isPressed {
        RoundedRectangle(cornerRadius: .Number100)
          .fill(ColorSet.Component.Pressed)
      }
    }
  }
  
}

#Preview {
  ResearchButton(action: {
    print("Action")
  })
}

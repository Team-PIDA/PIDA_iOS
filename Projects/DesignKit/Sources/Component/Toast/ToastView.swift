//
//  ToastView.swift
//  DesignKit
//
//  Created by Jiyeon on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct ToastView: View {
  
  @Binding var message: String?
  @State private var isVisible = false
  @State private var height: CGFloat = 4
  @State private var textOpacity: Double = 0
  @State private var boxOpacity: Double = 1
  
  private var buttonLabel: String?
  var action: (() async -> Void)?
  
  public init(
    message: Binding<String?>,
    buttonLabel: String? = nil,
    action: (() async -> Void)? = nil
  ) {
    self._message = message
    self.buttonLabel = buttonLabel
    self.action = action
  }
  
  public var body: some View {
    VStack {
      Spacer()
      if isVisible, let message {
        ZStack(alignment: .bottomLeading) {
          RoundedRectangle(cornerRadius: .Number10)
            .fill(ColorSet.Background.Inverse)
            .frame(height: height)
            .frame(maxWidth: .infinity)
          HStack {
            Text(message)
              .fontStyle(FontSet.Body.body2)
              .foregroundStyle(ColorSet.Text.Inverse)
              .opacity(textOpacity)
              .frame(maxWidth: .infinity, alignment: .leading)
            if let buttonLabel, let action {
              Button(action: {
                Task { @MainActor in await action() }
              }) {
                Text(buttonLabel)
                  .fontStyle(FontSet.Label.label1)
                  .foregroundStyle(ColorSet.Text.InverseAccent)
                  .padding(.horizontal, .Number8)
                  .opacity(textOpacity)
              }
            }
          }
          .padding(.vertical, .Number12)
          .padding([.leading], .Number16)
          .padding([.trailing], .Number12)
        }
        .opacity(boxOpacity)
        .padding(.Number16)
        .clipped()
      }
    }
    .onChange(of: message) {
      showToastIfNeeded()
    }
  }
  
  private func showToastIfNeeded() {
    guard let message = message, !message.isEmpty else { return }
    Task {
      // 초기 상태: 얇은 박스 + 텍스트는 아래쪽에 살짝만
      height = 4
      textOpacity = 0
      boxOpacity = 1
      isVisible = true
      
      // 박스가 위로 펼쳐짐
      withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
        height = 48
      }
      
      // 텍스트가 위로 올라오며 보임
      try? await Task.sleep(for: .seconds(0.05))
      withAnimation(.easeOut(duration: 0.1)) {
        textOpacity = 1.0
      }
      
      // 사라질 때: 전체 박스와 텍스트 페이드아웃
      try? await Task.sleep(for: .seconds(1.6))
      withAnimation(.easeInOut(duration: 0.2)) {
        boxOpacity = 0
      }
      
      try? await Task.sleep(for: .seconds(0.2))
      isVisible = false
      self.message = nil
      
    }
  }
}

#Preview {
  ToastPreiview()
}

struct ToastPreiview: View {
  @State var message: String? = ""
  @State var title: Int = 0
  var body: some View {
    ZStack {
      VStack {
        Button("\(title)") {
          message = "토스트 메세지!"
        }
      }
      Spacer()
      ToastView(
        message: $message,
        buttonLabel: "label"
      )
      .action {
        title += 1
      }
    }
  }
}

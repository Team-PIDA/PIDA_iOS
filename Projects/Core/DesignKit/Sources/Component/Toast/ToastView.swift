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
  @State private var verticalPadding: CGFloat = 4
  @State private var boxOpacity: Double = 1
  
  public init(message: Binding<String?>) {
    self._message = message
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
          
          Text(message)
            .fontStyle(FontSet.Body.body2)
            .foregroundStyle(ColorSet.Text.Inverse)
            .padding(.horizontal, .Number16)
            .padding(.vertical, verticalPadding)
            .opacity(textOpacity)
            .frame(maxWidth: .infinity, alignment: .leading)
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
    
    // 초기 상태: 얇은 박스 + 텍스트는 아래쪽에 살짝만
    height = 4
    textOpacity = 0
    verticalPadding = 4
    boxOpacity = 1
    isVisible = true
    
    // 박스가 위로 펼쳐짐
    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
      height = 48
    }
    
    // 텍스트가 위로 올라오며 보임
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
      withAnimation(.easeOut(duration: 0.1)) {
        textOpacity = 1.0
        verticalPadding = .Number12
      }
    }
    
    // 사라질 때: 전체 박스와 텍스트 페이드아웃
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
      withAnimation(.easeInOut(duration: 0.2)) {
        boxOpacity = 0
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        isVisible = false
        self.message = nil
      }
    }
  }
}


#Preview {
  ToastPreiview()
}

struct ToastPreiview: View {
  @State var message: String? = ""
  var body: some View {
    ZStack {
      VStack {
        Button("SHOW") {
          message = "토스트 메세지!"
        }
      }
      Spacer()
      ToastView(message: $message)
    }
  }
}

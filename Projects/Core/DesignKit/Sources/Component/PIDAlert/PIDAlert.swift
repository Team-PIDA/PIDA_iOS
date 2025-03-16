//
//  PIDAlert.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct PIDAlert: View {
  public var title: String
  public var message: String?
  public var closeAction: () async -> Void
  public var acceptAction: () async -> Void
  
  public init(
    title: String,
    message: String? = nil,
    closeAction: @escaping () async -> Void,
    acceptAction: @escaping () async -> Void
  ) {
    self.title = title
    self.message = message
    self.closeAction = closeAction
    self.acceptAction = acceptAction
  }
  
  public var body: some View {
    content
      .background(ColorSet.Background.Primary)
      .fixedSize(horizontal: false, vertical: true)
      .frame(width: .Number320)
  }
  
  @ViewBuilder
  private var content: some View {
    VStack(spacing: .Number20) {
      titleView
      buttonView
    }
    .padding(.horizontal, .Number16)
    .padding(.top, .Number20)
    .padding(.bottom, .Number16)
  }
  
  @ViewBuilder
  private var titleView: some View {
    VStack(spacing: .Number8) {
      Text(title)
        .font(FontSet.Title.title2)
        .multilineTextAlignment(.center)
      
      if let message = message {
        Text(message)
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .multilineTextAlignment(.center)
      }
    }
  }
  
  @ViewBuilder
  private var buttonView: some View {
    HStack(spacing: .Number12) {
      PIDButton()
      .title("닫기")
      .isSecondary(true)
      .action {
        Task { @MainActor in
          await closeAction()
        }
      }
      
      PIDButton()
      .title("확인")
      .action {
        Task { @MainActor in
          await acceptAction()
        }
      }
    }
  }
}

#Preview {
  PIDAlert(
    title: "알림",
    message: "알림 메시지입니다.\n2줄 짜리임.",
    closeAction: {
      print("닫기 버튼")
    },
    acceptAction: {
      print("확인 버튼")
    }
  )
}

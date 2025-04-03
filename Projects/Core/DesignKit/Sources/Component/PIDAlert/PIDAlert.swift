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
  public var cancelTitle: String
  public var acceptTitle: String
  public var closeAction: () async -> Void
  public var acceptAction: () async -> Void
  var isErrorType: Bool = true
  
  public init(
    type: AlertType,
    closeAction: @escaping () async -> Void,
    acceptAction: @escaping () async -> Void
  ) {
    self.title = type.title
    self.message = type.message
    self.cancelTitle = type.cancel
    self.acceptTitle = type.accept
    self.closeAction = closeAction
    self.acceptAction = acceptAction
  }
  
  public var body: some View {
    ZStack {
      ColorSet.SubColor.backdrop
        .ignoresSafeArea()
      content
        .background(
          RoundedRectangle(cornerRadius: .Number10)
            .fill(ColorSet.Background.Primary)
        )
        .fixedSize(horizontal: false, vertical: true)
        .frame(width: .Number320)
    }
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
        .fontStyle(FontSet.Title.title2)
        .foregroundStyle(ColorSet.Text.Primary)
        .multilineTextAlignment(.center)
      
      if let message = message {
        Text(message)
          .fontStyle(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .multilineTextAlignment(.center)
      }
    }
  }
  
  @ViewBuilder
  private var buttonView: some View {
    HStack(spacing: .Number12) {
      PIDButton(
        title: cancelTitle,
        size: .large
      )
      .isSecondary(true)
      .action {
        Task { @MainActor in
          await closeAction()
        }
      }
      
      PIDButton(
        title: acceptTitle,
        size: .large
      )
      .isError(isErrorType)
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
    type: .logout,
    closeAction: {
      print("닫기 버튼")
    },
    acceptAction: {
      print("확인 버튼")
    }
  )
}

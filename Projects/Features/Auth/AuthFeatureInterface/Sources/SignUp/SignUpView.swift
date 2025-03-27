//
//  SignUpView.swift
//  AuthFeatureInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import Utility

public struct SignUpView: View {
  @Bindable var store: StoreOf<SignUpReducer>
  
  public init(store: StoreOf<SignUpReducer>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack(alignment: .leading ,spacing: .Number0) {
        Spacer()
          .frame(height: .Number48)
        
        nicknameTitle
        
        nicknameTextField
        
        Spacer()
        
        completeButton
      }
      .padding(.horizontal, .Number16)
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var nicknameTitle: some View {
    Text("닉네임을 입력해주세요")
      .fontStyle(FontSet.Heading.heading1)
      .foregroundStyle(ColorSet.Text.Primary)
  }
  
  @ViewBuilder
  private var nicknameTextField: some View {
    PIDATextField(
      text: $store.nickname.removeDuplicates(),
      placeholder: "닉네임",
      isFocused: $store.focusKeyboard
    )
    .message("2~12자까지 입력할 수 있어요.")
    .borderStyle(.accent)
    .padding(.vertical, .Number24)
  }
  
  @ViewBuilder
  private var completeButton: some View {
    PIDButton(title: "완료", size: .large)
      .action {
        store.send(.dismiss)
      }
      .padding(.vertical, .Number16)
  }
  
}



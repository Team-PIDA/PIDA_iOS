//
//  ProfileUpdateView.swift
//  SettingDemo
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct ProfileUpdateView: View {
  @Bindable var store: StoreOf<ProfileUpdateReducer>
  
  public init(store: StoreOf<ProfileUpdateReducer>) {
    self.store = store
  }
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack {
        navigationBar
        nicknameTextField
        Spacer()
        saveButton
      }
    }
    .navigationBarBackButtonHidden(true)
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var navigationBar: some View {
    NavigationGestureSupportView()
      .frame(width: .Number0, height: .Number0)
    NavigationBar(
      backContent: {
        TouchArea(image: .back)
          .size(.superLarge)
          .action {
            store.send(.pop)
          }
      },
      title: "닉네임 변경"
    )
  }
  
  @ViewBuilder
  private var nicknameTextField: some View {
    PIDATextField(
      text: $store.changeName,
      placeholder: "닉네임",
      isFocused: $store.focusKeyboard
    )
    .message(store.inputValid.text)
    .borderStyle(!store.isValidInput ? .error: .accent)
    .padding(.horizontal, .Number16)
  }
  
  @ViewBuilder
  private var saveButton: some View {
    PIDButton(title: "저장하기", size: .large)
      .action {
        store.send(.saveTapped)
      }
      .isActive(store.inputValid.isValid)
      .padding(.Number16)
  }
  
}

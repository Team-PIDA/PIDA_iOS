//
//  AuthView.swift
//
//  Auth
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct AuthView: View {
  let store: StoreOf<AuthReducer>

  public init(store: StoreOf<AuthReducer>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      NavigationBar(
        closeContent:  {
        TouchArea(image: .close)
          .size(.superLarge)
          .action {
            store.send(.dismiss)
          }
        }
      )
      Spacer()
      VStack(spacing: .Number10) {
        appleLogin
      }
      .padding(.horizontal, .Number16)
    }
  }
  
  @ViewBuilder
  private var appleLogin: some View {
    PIDButton(
      title: "Apple로 로그인하기",
      size: .large
    ) {
      Icon(image: .apple)
        .size(.large)
        .foregroundColor(ColorSet.Background.Primary)
    }
    .action {
      store.send(.appleLoginButtonTapped)
    }
    .backgroundColor(ColorSet.Background.Inverse)
    .foregroundStyle(ColorSet.Background.Primary)
    .frame(height: .Number48)
  }
}


//
//  AuthView.swift
//
//  Auth
//
//  Created by JiYeon
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct AuthView: View {
  let store: StoreOf<AuthFeature>
  
  public init(store: StoreOf<AuthFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack{
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack {
        navigationBar
        VStack(spacing: .Number16) {
          Spacer()
          Image(asset: ImageSet.loginLogo.swiftUIImage)
          Text("이메일이나 비밀번호 없이 3초안에 로그인하세요")
            .fontStyle(FontSet.Body.body3)
            .foregroundStyle(ColorSet.Text.Secondary)
          Spacer()
        }
        VStack(spacing: .Number10) {
          Spacer()
            .frame(height: 48)
          appleLogin
        }
        .padding(.Number16)
      }
    }
  }
  
  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      closeContent:  {
      TouchArea(image: .close)
        .size(.superLarge)
        .action {
          store.send(.dismiss)
        }
      }
    )
  }
  
  @ViewBuilder
  private var appleLogin: some View {
    PIDButton(
      title: "Apple로 계속하기",
      size: .large
    ) {
      Icon(image: .apple)
        .size(.large)
        .foregroundColor(ColorSet.Background.Primary)
    }
    .action {
      store.send(.appleLoginButtonTapped)
    }
    .backgroundColor(ColorSet.Gray._1000)
    .foregroundStyle(ColorSet.Background.Primary)
    .frame(height: .Number48)
  }
}

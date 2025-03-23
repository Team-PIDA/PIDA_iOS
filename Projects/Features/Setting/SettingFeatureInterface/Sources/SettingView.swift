//
//  SettingView.swift
//
//  Setting
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

import DesignKit

public struct SettingView: View {
  let store: StoreOf<SettingReducer>
  
  public init(store: StoreOf<SettingReducer>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      navigationBar
      profileView
        
      Spacer()
    }
    .navigationBarBackButtonHidden(true)
  }
}

extension SettingView {
  /// 네비게이션 바
  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .back)
          .size(.superLarge)
          .action {
            store.send(.pop)
          }
      },
      title: "마이페이지"
    )
  }
  
  @ViewBuilder
  private var profileView: some View {
    HStack(spacing: .Number16) {
      Image(asset: ImageSet.avatarLarge.swiftUIImage)
        .resizable()
        .frame(width: .Number40, height: .Number40)
      
      if store.isLoggedIn, let username = store.username {
        Text("환영해요! \(username)님")
      } else {
        HStack(spacing: .Number0) {
          Text("로그인 하기")
            .font(FontSet.Body.body2)
            
          Icon(image: .chevronRight)
            .size(.extraLarge)
        }
      }
      Spacer()
    }
    .font(FontSet.Body.body2)
    .foregroundStyle(ColorSet.Text.Primary)
    .padding(.horizontal, .Number16)
  }
}

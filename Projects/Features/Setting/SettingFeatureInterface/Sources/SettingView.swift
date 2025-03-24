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
    VStack(spacing: .Number0) {
      navigationBar
      VStack(spacing: .Number0) {
        profileView
        
        feedBackView
          .padding(.horizontal, .Number16)
        
        SettingItemListView(title: "서비스", items: serviceItems()) {
          store.send(.settingListTapped($0))
        }
        
        if store.isLoggedIn {
          BorderView(size: .xlarge)
          SettingItemListView(items: accountItems()) {
            store.send(.settingListTapped($0))
          }
        }
      }
      
      Spacer()
    }
    .navigationBarBackButtonHidden(true)
    .onAppear {
      store.send(.onAppear)
    }
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
    HStack(alignment: .center, spacing: .Number16) {
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
    .frame(height: .Number72)
  }
  
  @ViewBuilder
  private var feedBackView: some View {
    HStack(spacing: .Number12) {
      Image(asset: ImageSet.loveletter.swiftUIImage)
        .resizable()
        .frame(width: .Number40, height: .Number40)
      
      VStack(alignment: .leading, spacing: .Number2) {
        Text("피드백 남기러 가기")
          .font(FontSet.Title.title3)

        Text("좋은 점, 개선할 점, 궁금한 점 의견을 들려주세요!")
          .font(FontSet.Caption.caption1)
          .foregroundStyle(ColorSet.Text.Secondary)
      }
      Spacer()
    }
    .padding(.vertical, .Number16)
    .padding(.horizontal, .Number16)
    .background(
      RoundedRectangle(cornerRadius: .Number10)
        .fill(ColorSet.Background.Accent)
    )
    .frame(height: .Number76)
  }
  
}

// MARK: - Data

extension SettingView {
  private func serviceItems() -> [SettingItem] {
    [
      .init(type: .update, title: "최신버전 업데이트", subtitle: "v2.0/v1.0", trailing: "업데이트"),
      .init(type: .terms, title: "서비스 이용약관"),
      .init(type: .privacy, title: "개인정보 처리방침")
    ]
  }
  
  private func accountItems() -> [SettingItem] {
    [
      .init(type: .logout, title: "로그아웃"),
      .init(type: .withdraw, title: "탈퇴하기")
    ]
  }
}

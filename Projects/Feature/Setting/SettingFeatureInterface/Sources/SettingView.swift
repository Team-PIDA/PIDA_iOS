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
  @Bindable var store: StoreOf<SettingFeature>
  
  public init(store: StoreOf<SettingFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack(spacing: .Number0) {
        navigationBar
        VStack(spacing: .Number0) {
          profileView
          settingListView
        }
        
        Spacer()
      }
      if let alertType = store.alertType {
        alertView(type: alertType)
      }
    }
    .navigationBarBackButtonHidden(true)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

extension SettingView {
  
  @ViewBuilder
  private var settingListView: some View {
    SettingItemListView(title: "서비스", items: serviceItems()) {
      store.send(.settingListTapped($0))
    }
    BorderView(size: .xlarge)
    SettingItemListView(title: "기타", items: etcItems()) {
      store.send(.settingListTapped($0))
    }
    
    if store.isLoggedIn {
      BorderView(size: .xlarge)
      SettingItemListView(items: accountItems()) {
        store.send(.settingListTapped($0))
      }
    }
  }
  
  /// 네비게이션 바
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
      title: "마이페이지"
    )
  }
  
  @ViewBuilder
  private var profileView: some View {
    VStack(spacing: .Number16) {
      HStack(alignment: .center, spacing: .Number16) {
        Image(asset: ImageSet.avatarLarge.swiftUIImage)
        HStack(spacing: .Number0) {
          if store.isLoggedIn {
            HStack(spacing: .Number0) {
              Text("환영해요! ")
                .fontStyle(FontSet.Body.body2)
              Text(store.username)
                .fontStyle(FontSet.Title.title3)
              Text("님")
                .fontStyle(FontSet.Body.body2)
            }
          } else {
            Text("로그인 하기")
          }
          Icon(image: .chevronRight)
            .size(.extraLarge)
        }
        Spacer()
      }
      .fontStyle(FontSet.Body.body2)
      .foregroundStyle(ColorSet.Text.Primary)
      .padding(.top, .Number16)
      .onTapGesture {
        store.send(.profileTapped)
      }
      BorderView(size: .short)
    }
    .padding(.horizontal, .Number16)
  }
  
  @ViewBuilder
  private var nicknameText: some View {
    Text(store.username)
      .fontStyle(FontSet.Title.title3)
  }
  
  private func alertView(type: AlertType) -> some View {
    PIDAlert(
      type: type,
      closeAction: { store.send(.alertCancelTapped) },
      acceptAction: { store.send(.alertAcceptTapped(type)) }
    )
  }
}

// MARK: - Data

extension SettingView {
  
  private func serviceItems() -> [SettingItem] {
    [
      .init(type: .report, title: "꽃길 제보하기", icon: .location),
      .init(type: .feedback, title: "피드백 남기기", icon: .feedback)
    ]
  }
  
  private func etcItems() -> [SettingItem] {
    [
      .init(type: .update, title: "최신버전 업데이트", subtitle: store.version, trailing: store.isNeedUpdate ? "업데이트" : "최신버전 사용 중"),
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

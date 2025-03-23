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
      Spacer()
    }
    .navigationBarBackButtonHidden(true)
  }
}


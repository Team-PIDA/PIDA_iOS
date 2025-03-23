//
//  SettingView.swift
//
//  Setting
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public struct SettingView: View {
  let store: StoreOf<SettingReducer>

  public init(store: StoreOf<SettingReducer>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


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

public struct SignUpView: View {
  let store: StoreOf<SignUpReducer>
  
  public init(store: StoreOf<SignUpReducer>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack {
        PIDButton(title: "완료", size: .large)
          .action {
            store.send(.dismiss)
          }
      }
    }
  }
}



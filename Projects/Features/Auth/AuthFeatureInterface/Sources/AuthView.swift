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
          .size(.superLage)
          .action {
            
          }
        }
      )
      Spacer()
    }
  }
}


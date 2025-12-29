//
//  PolicyView.swift
//  SettingFeatureInterface
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit

import ComposableArchitecture

public struct PolicyView: View {
  
  let store: StoreOf<PolicyFeature>
  
  public init(store: StoreOf<PolicyFeature>) {
    self.store = store
  }
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack(spacing: .Number0) {
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
          title: store.type?.title
        )
        if let type = store.type, let url = type.url {
          WebView(url: url)
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    
  }
}

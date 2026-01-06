//
//  PIDAView.swift
//  PIDA
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import MapFeatureInterface
import SearchFeatureInterface
import SettingFeatureInterface
import AuthFeatureInterface
import BloomingFeatureInterface
import FlowerSpotDetailFeatureInterface

struct PIDAView: View {
  @Bindable var store: StoreOf<PIDAFeature> = Store(initialState: PIDAFeature.State()) { PIDAFeature()
  }
  var body: some View {
    NavigationStack(path: $store.path) {
      MapView(store: store.scope(state: \.map, action: \.map))
        .navigationDestination(for: Path.self) { path in
          switch path {
          case .setting:
            IfLetStore(store.scope(state: \.setting, action: \.setting)) { store in
              SettingView(store: store)
            }
          case .policy:
            IfLetStore(store.scope(state: \.policy, action: \.policy)) { store in
              PolicyView(store: store)
            }
          case .update:
            IfLetStore(store.scope(state: \.update, action: \.update)) { store in
              ProfileUpdateView(store: store)
            }
          }
        }
        .fullScreenCover(isPresented: $store.isPresentBlooming) {
          IfLetStore(store.scope(state: \.blooming, action: \.blooming)) { store in
            BloomingUpdateView(store: store)
          }
        }
        .fullScreenCover(isPresented: $store.isPresentSignUp) {
          IfLetStore(store.scope(state: \.signUp, action: \.signUp)) { store in
            SignUpView(store: store)
          }
        }
        .fullScreenCover(isPresented: $store.isPresentAuth) {
          IfLetStore(store.scope(state: \.auth, action: \.auth)) { store in
            AuthView(store: store)
          }
        }
        .fullScreenCover(isPresented: $store.isShowSearch) {
          IfLetStore(store.scope(state: \.search, action: \.search)) { store in
            SearchView(store: store)
          }
        }
        .fullScreenCover(isPresented: $store.isPresentFlowerSpotDetail) {
          IfLetStore(store.scope(state: \.flowerSpotDetail, action: \.flowerSpotDetail)) { store in
            FlowerSpotDetailView(store: store)
          }
        }
        .transaction { transaction in
          transaction.disablesAnimations = true
        }
    }
  }
  
}

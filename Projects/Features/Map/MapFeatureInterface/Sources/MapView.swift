//
//  MapView.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct MapView: View {
  
  private typealias Icons = DesignKitAsset.Icons
  private typealias Colors = DesignKitAsset.ColorSet
  
  
  
  public init(store: StoreOf<MapReducer>) {
    self.store = store
  }
  
  public var body: some View {
    MapViewRepresentable()
      .ignoresSafeArea()
    VStack {
      Spacer()
      HStack {
        Spacer()
        curLocationButton()
      }
    }
    .padding(.trailing, 16)
      
    }
    
  }
  
  
  private func curLocationButton() -> some View {
    Button {
      store.send(.fetchUserLocation)
    } label: {
      Image(asset: Icons.myLocation).renderingMode(.template)
    }
    .foregroundStyle(Colors.Icon.Primary)
    .frame(width: 48, height: 48)
    .background(Colors.Background.Primary)
    .clipShape(.circle)
    .shadow(color: .black.opacity(0.2), radius: 4)
  }
}

//#Preview {
//  MapView(store: Store(initialState: MapReducer.State(), reducer: {
//    MapReducer()
//  }))
//}

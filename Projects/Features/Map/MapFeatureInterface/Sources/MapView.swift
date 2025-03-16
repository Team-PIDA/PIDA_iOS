//
//  MapView.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import Combine
import ComposableArchitecture
import DesignKit
import Utility

public struct MapView: View {
  
  private typealias Icons = DesignKitAsset.Icons
  private typealias Colors = DesignKitAsset.ColorSet
  
  @Bindable var store: StoreOf<MapReducer>
  private var markerTappedEvent = PassthroughSubject<Int?, Never>()
  
  public init(store: StoreOf<MapReducer>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      MapViewRepresentable(
        userLocation: $store.state.position,
        flowerPositions: $store.state.flowerPositions,
        selectedPath: $store.state.selectedPathLines,
        markerTappedEvent: markerTappedEvent
      )
      .onReceive(markerTappedEvent) {
        store.send(.fetchPathLines(id: $0))
      }
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
    .onAppear {
      store.send(.fetchUserLocation)
      store.send(.fetchFlowers)
    }
    .onReceive(LocationService.shared.userLocationEvent) { _ in
      store.send(.moveUserLocation)
    }
  }
  
  // TODO: - DesignSystem 버튼으로 변경
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

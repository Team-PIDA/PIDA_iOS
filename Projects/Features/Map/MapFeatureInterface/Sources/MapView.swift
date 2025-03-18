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
        newPath: $store.state.selectedPathLines,
        markerTappedEvent: markerTappedEvent
      )
      .onReceive(markerTappedEvent) {
        store.send(.fetchPathLines(id: $0))
      }
      .ignoresSafeArea()
      VStack {
        Spacer()
        currentButton
      }
    }
    .onAppear {
      store.send(.fetchUserLocation)
      store.send(.fetchFlowers)
    }
    .task {
      for await _ in await LocationService.shared.userLocationStream {
        store.send(.moveUserLocation)
      }
    }
  }
  
  @ViewBuilder
  private var currentButton: some View {
    HStack {
      Spacer()
      PIDIconButton {
        Icon(image: .myLocation)
          .size(.superLage)
      }
      .action {
        store.send(.fetchUserLocation)
      }
      .elevation(cornerRadius: .Number24)
    }
    .padding(.trailing, .Number16)
  }
}

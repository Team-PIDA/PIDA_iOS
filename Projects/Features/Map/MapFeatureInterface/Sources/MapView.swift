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
        Button {
          store.send(.push)
        } label: {
          Text("HELLO")
        }

        Spacer()
        currentButton
      }
    }
    .onAppear {
      store.send(.fetchUserLocation)
      store.send(.fetchFlowers)
    }
    .task {
      for await _ in LocationService.shared.userLocationStream {
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

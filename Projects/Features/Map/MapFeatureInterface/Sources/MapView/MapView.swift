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
  
  @State var searchText: String = ""
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
        searchView(text: $searchText)
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
  
  
}


extension MapView {
  private func searchView(text: Binding<String>) -> some View {
    SearchBar(
      text: text,
      placeholder: "방문할 장소를 입력하세요",
      mode: .main,
      trailingContent:  {
        settingButton
      }
    )
    .onTap {
      print("TOUCH")
    }
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number8)
  }
  
  @ViewBuilder
  private var settingButton: some View {
    PIDIconButton {
      Image(asset: ImageSet.avatar.swiftUIImage)
        .resizable()
        .scaledToFit()
        .frame(width: .Number32, height: .Number32)
    }
  }
  
  @ViewBuilder
  private var currentButton: some View {
    HStack {
      Spacer()
      PIDIconButton {
        Icon(image: .myLocation)
          .size(.superLarge)
      }
      .action {
        store.send(.fetchUserLocation)
      }
      .elevation(cornerRadius: .Number24)
    }
    .padding(.trailing, .Number16)
  }
}

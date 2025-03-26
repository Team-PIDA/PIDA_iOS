//
//  MapView.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import Combine

import FlowerSpotDomainInterface
import DesignKit
import Utility

import ComposableArchitecture

public struct MapView: View {
  @Bindable var store: StoreOf<MapReducer>
  
  private var markerTappedEvent = PassthroughSubject<Int?, Never>()
  private var requestMapBounds = PassthroughSubject<[MapPoint], Never>()
  
  public init(store: StoreOf<MapReducer>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      mapView
      VStack {
        searchView()
          .padding(.horizontal, .Number16)
          .padding(.vertical, .Number8)
        if store.researchButtonEnable {
          ResearchButton(
            action: {
              store.send(.requestMapBounds(true))
            }
          )
        }
        Spacer()
        currentButton
      }
    }
    .onAppear {
      store.send(.fetchUserLocation)
    }
    .task {
      for await _ in LocationService.shared.userLocationStream {
        store.send(.moveUserLocation)
      }
    }
  }
  
  
}

// MARK: - Views

extension MapView {
  
  @ViewBuilder
  private var mapView: some View {
    MapViewRepresentable(
      userLocation: $store.state.point,
      flowerPositions: $store.state.flowerSpots,
      newPath: $store.state.selectedPathLines,
      requestBounds: $store.requestMapBound,
      markerTappedEvent: markerTappedEvent,
      isCameraMove: $store.researchButtonEnable
    )
    .onReceiveMapBounds {
      store.send(.fetchFlowers($0))
    }
    .onReceive(markerTappedEvent) {
      store.send(.fetchPathLines(id: $0))
    }
    .ignoresSafeArea()
  }
  
  @ViewBuilder
  private func searchView() -> some View {
    // TODO: - ontap 시 textfield에 텍스트 세팅
    if let result = store.searchText { // 검색 결과
      SearchBar(
        text: .constant(result),
        placeholder: "",
        mode: .result,
        leadingContent: {
          TouchArea(image: .back)
            .size(.extraLarge)
            .action {
              store.send(.resetSearchBar)
            }
        }
      )
      .onTap {
        store.send(.presentToSearch)
      }
    } else { // 검색
      SearchBar(
        placeholder: "방문할 장소를 입력하세요",
        mode: .main,
        trailingContent: {
          settingButton
        }
      )
      .onTap {
        store.send(.presentToSearch)
      }
    }
  }
  
  @ViewBuilder
  private var settingButton: some View {
    PIDIconButton {
      Image(asset: ImageSet.avatar.swiftUIImage)
        .resizable()
        .scaledToFit()
        .frame(width: .Number32, height: .Number32)
    }
    .action {
      store.send(.pushToSetting)
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

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
  
  public init(store: StoreOf<MapReducer>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
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
        ToastView(message: $store.toastMessage)
        currentButton
      }
    }
    .overlay(
        Group {
          if store.isBottomSheetPresented {
            let item = store.selectedItemDetail
            let bloomingStatus = store.selectedItemBlooming
            CherryBlossomBottomSheet(
              title: item?.streetName,
              description: item?.address,
              tags: [item?.district, item?.recentlyVisitedCountString],
              blossomState: item?.bloomingStatus,
              isLoading: store.isDetailLoading,
              onPullUp: {
                return await MainActor.run {
                  if let item = item,
                     let bloomingStatus = bloomingStatus {
                    store.send(
                      .presentToDetail(
                        flowerSpotData: item,
                        bloomingStatus: bloomingStatus
                      )
                    )
                  }
                }
              },
              onPullDown:  {
                return await MainActor.run {
                  store.send(.resetSearchBar)
                  store.send(.dismissBottomSheet)
                  store.send(.markerTapped(id: nil))
                }
              },
              onTap: {
                return await MainActor.run {
                  if let item = item,
                     let bloomingStatus = bloomingStatus {
                    store.send(
                      .presentToDetail(
                        flowerSpotData: item,
                        bloomingStatus: bloomingStatus
                      )
                    )
                  }
                }
              })
          }
        },
        alignment: .bottom
      )
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      if !store.isViewAppeared {
        store.send(.fetchUserLocation)
        store.send(.viewDidAppear)
      }
      
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
      isCameraMove: $store.researchButtonEnable,
      focusData: $store.searchResult,
      isNeedDeleteMarker: $store.isNeedDeleteMarker,
      isNeedDrawMarker: $store.isNeedDrawMarker
    )
    .onReceiveMapBounds {
      if store.requestMapBound {
        store.send(.fetchFlowers($0))
      }
    }
    .onMarkerTapped { id in
      store.send(.markerTapped(id: id))
      if id == .none {
        store.send(.dismissBottomSheet)
      }
    }
    .ignoresSafeArea()
  }
  
  @ViewBuilder
  private func searchView() -> some View {
    // TODO: - ontap 시 textfield에 텍스트 
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
              store.send(.dismissBottomSheet)
              store.send(.markerTapped(id: nil))
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
    .padding(.bottom, store.selectedItemDetail != nil ? 180 : 40)
  }
}

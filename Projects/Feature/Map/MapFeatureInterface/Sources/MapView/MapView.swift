//
//  MapView.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import Shared
import DesignKit
import ComposableArchitecture
import FlowerSpotClient
import BloomingClient

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
              store.send(.location(.requestMapBounds(true)))
            }
          )
        }
        
        Spacer()
        ToastView(message: $store.toastMessage, buttonLabel: store.toastLabel)
          .action {
            store.send(.toastActionTapped)
          }
        currentButton
      }
      if let type = store.alertType {
        alertView(type: type)
      }
    }
    .overlay(
        Group {
          if store.detail.isBottomSheetPresented {
            if let item = store.detail.selectedItemDetail,
               let bloomingStatus = store.detail.selectedItemBlooming,
               let isVotedBlooming = store.detail.selectedItemVote {
              BottomSheet(item: item, bloomingStatus: bloomingStatus, isVotedBlooming: isVotedBlooming)
            }
          }
        },
        alignment: .bottom
      )
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      if !store.isViewAppeared {
        store.send(.location(.moveUserLocation))
        store.send(.viewDidAppear)
      }
    }
  }
  
  
}

// MARK: - Views

extension MapView {
  
  @ViewBuilder
  private var mapView: some View {
    MapViewRepresentable(
      userLocation: $store.point,
      flowerPositions: $store.state.flowerSpots,
      newPath: $store.state.selectedPathLines,
      requestBounds: $store.requestMapBound,
      isCameraMove: $store.researchButtonEnable,
      focusData: $store.searchResult,
      isNeedDeleteMarker: $store.isNeedDeleteMarker,
      isNeedDrawMarker: $store.isNeedDrawMarker,
      updateMarkerStatus: $store.detail.updateMarkerStatus
    )
    .onReceiveMapBounds {
      if store.requestMapBound {
        store.send(.location(.fetchFlowers($0)))
      }
    }
    .onMarkerTapped { id in
      store.send(.markerTapped(id: id))
      if id == .none {
        store.send(.detail(.dismissBottomSheet))
      }
    }
    .ignoresSafeArea()
  }
  
  @ViewBuilder
  private func searchView() -> some View {
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
              store.send(.detail(.dismissBottomSheet))
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
  private func BottomSheet(
    item: FlowerSpotEntity,
    bloomingStatus: BloomStatusEntity,
    isVotedBlooming: VerifyBloomingStateEntity
  ) -> some View {
    CherryBlossomBottomSheet(
      title: item.streetName,
      description: item.address,
      tags: [
        .district(value: item.district),
        .recentVisitCount(value: item.recentlyVisitedCountString),
        bloomingStatus.nickname == nil ? nil : .informant(value: bloomingStatus.nickname!)
      ],
      blossomState: BloomStatus(rawValue: item.bloomingStatus),
      isLoading: store.detail.isDetailLoading,
      onPullUp: {
        return await MainActor.run {
          store.send(
            .detail(
              .presentToDetail(
                flowerSpotData: item,
                bloomingStatus: bloomingStatus,
                distance: store.detail.distance,
                isVotedBlooming: isVotedBlooming
              )
            )
          )
        }
      },
      onPullDown:  {
        return await MainActor.run {
          store.send(.resetSearchBar)
          store.send(.detail(.dismissBottomSheet))
          store.send(.markerTapped(id: nil))
        }
      },
      onTap: {
        return await MainActor.run {
          store.send(
            .detail(
              .presentToDetail(
                flowerSpotData: item,
                bloomingStatus: bloomingStatus,
                distance: store.detail.distance,
                isVotedBlooming: isVotedBlooming
              )
            )
          )
        }
      }
    )
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
        store.send(.location(.currentButtonTapped(true)))
      }
      .elevation(cornerRadius: .Number24)
    }
    .padding(.trailing, .Number16)
    .padding(.bottom, store.detail.selectedItemDetail != nil ? 180 : 40)
  }
  
  private func alertView(type: AlertType) -> some View {
    PIDAlert(
      type: type,
      closeAction: { store.send(.alertCancelTapped) },
      acceptAction: { store.send(.alertAcceptTapped(type)) }
    )
    .isErrorType(false)
  }
}

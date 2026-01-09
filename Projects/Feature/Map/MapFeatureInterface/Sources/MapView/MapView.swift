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
import FlowerSpotDetailFeatureInterface
import SearchRegionListFeatureInterface

public struct MapView: View {
  @Bindable var store: StoreOf<MapFeature>

  /// 바텀시트 드래그 활성화 여부 (스크롤 ↔ 드래그 충돌 제어)
  @State private var isDragEnabled: Bool = true
  /// 바텀시트 확장 상태 여부
  @State private var isBottomSheetExpanded: Bool = false

  
  
  public init(store: StoreOf<MapFeature>) {
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
        ToastView(message: $store.toastMessage, buttonLabel: store.toastLabel)
          .action {
            store.send(.moveToReportURL)
          }
        currentButton
      }
      if let type = store.alertType {
        alertView(type: type)
      }
    }
    .overlay(
        Group {
          if let detailStore = store.scope(
            state: \.flowerSpotDetail,
            action: \.flowerSpotDetail
          ) {
            newBottomSheet(detailStore: detailStore)
          }
        },
        alignment: .bottom
      )
    .overlay {
      Group {
        if let store = store.scope(state: \.searchRegionList, action: \.searchRegionList) {
          regionListSheet(store: store)
        }
      }
    }
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
      userLocation: $store.location.point,
      flowerPositions: $store.state.flowerSpots,
      newPath: $store.state.selectedPathLines,
      requestBounds: $store.requestMapBound,
      isCameraMove: $store.researchButtonEnable,
      focusData: $store.searchResult,
      isNeedDeleteMarker: $store.isNeedDeleteMarker,
      isNeedDrawMarker: $store.isNeedDrawMarker,
      updateMarkerStatus: Binding(
        get: { store.flowerSpotDetail?.updateMarkerStatus },
        set: { _ in }
      )
    )
    .onReceiveMapBounds {
      if store.requestMapBound {
        store.send(.location(.fetchFlowers($0)))
      }
    }
    .onMarkerTapped { id in
      store.send(.markerTapped(id: id))
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
        store.send(.location(.currentButtonTapped(true)))
      }
      .elevation(cornerRadius: .Number24)
    }
    .padding(.trailing, .Number16)
    .padding(.bottom, store.flowerSpotDetail != nil ? 180 : 40)
  }
  
  private func alertView(type: AlertType) -> some View {
    PIDAlert(
      type: type,
      closeAction: { store.send(.alertCancelTapped) },
      acceptAction: { store.send(.alertAcceptTapped(type)) }
    )
    .isErrorType(false)
  }

  // MARK: - BottomSheet

  @ViewBuilder
  private func newBottomSheet(detailStore: StoreOf<FlowerSpotDetailFeature>) -> some View {
    CherryBlossomBottomSheet(
      isDragEnabled: $isDragEnabled,
      isExpanded: $isBottomSheetExpanded,
      smallContent: {
        if detailStore.isDetailLoading {
          FlowerSpotDetailSmallContentLoadingView()
        } else {
          FlowerSpotDetailSmallContentView(
            flowerSpotData: detailStore.flowerSpotData,
            bloomingStatus: detailStore.bloomingStatus
          )
        }
      },
      largeContent: {
        FlowerSpotDetailLargeContentView(
          store: detailStore,
          isDragEnabled: $isDragEnabled,
          onBackTapped: {
            isBottomSheetExpanded = false
          }
        )
      },
      onDismiss: {
        store.send(.flowerSpotDetail(.dismiss))
      }
    )
  }
  
  private func regionListSheet(store: StoreOf<SearchRegionListFeature>) -> some View {
    DetentBottomSheet(isPresented: $store.isShowRegionList) {
      SearchRegionListView(store: store)
    }
  }
}

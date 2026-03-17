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
import CategoryFeatureInterface
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
        headerSection()
        if store.researchButtonEnable && store.category.selectedCategory != .festival {
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
          regionListSheet(with: store)
        }
      }
    }
    .overlay {
      Group {
        if let categoryListStore = store.scope(state: \.categoryList, action: \.categoryList) {
          categoryListSheet(with: categoryListStore)
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
      flowerPositions: $store.spots,
      isCameraMove: $store.researchButtonEnable,
      hasBottomSheet: Binding(
        get: { store.mapSearch.isShowRegionList || store.category.isShowCategoryList },
        set: { _ in }
      ),
      mapActions: $store.mapActions,
      shouldRequestInitialBounds: $store.shouldRequestInitialBounds
    )
    .onReceiveMapBounds {
      store.send(.receiveMapBounds($0))
    }
    .onMarkerTapped { id in
      store.send(.markerTapped(id: id))
    }
    .cameraMoveEvent {
      store.send(.mapSearch(.changeRegionSheetDetent))
      store.send(.category(.changeCategorySheetDetent))
    }
    .ignoresSafeArea()
  }
  
  @ViewBuilder
  private func headerSection() -> some View {
    VStack(spacing: .Number10) {
      searchView()
        .padding(.horizontal, .Number16)
      if store.mapSearch.searchText == nil {
        categoryButton()
      }
    }
    .padding(.vertical, .Number8)
  }
  
  @ViewBuilder
  private func searchView() -> some View {
    if let result = store.mapSearch.searchText { // 검색 결과
      SearchBar(
        text: .constant(result),
        placeholder: "",
        mode: .result,
        leadingContent: {
          TouchArea(image: .back)
            .size(.extraLarge)
            .action {
              store.send(.mapSearch(.searchBackButtonTapped))
            }
        }
      )
      .onTap {
        store.send(.mapSearch(.presentToSearch))
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
        store.send(.mapSearch(.presentToSearch))
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
  
  private func categoryButton() -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: .Number8) {
        ForEach(store.category.categoryList, id: \.id) { item in
          CategoryButton(
            title: item.category,
            icon: item.type.icon,
            isActive: item.type == store.category.selectedCategory
          )
          .onTapGesture {
            store.send(.category(.tapCategory(item)))
          }
        }
      }
      .padding(.horizontal, .Number16)
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
      .padding(.bottom, .Number16)
    }
    .padding(.trailing, .Number16)
    .padding(.bottom, currentButtonBottomPadding)
  }
  
  private var currentButtonBottomPadding: CGFloat {
    if store.flowerSpotDetail != nil {
      return .detailBottomSheetHeight
    } else if store.mapSearch.isShowRegionList {
      return min(store.mapSearch.regionBottomSheetHeight, 500)
    } else if store.category.isShowCategoryList {
      return min(store.category.categoryListBottomSheetHeight, 500)
    } else {
      return 20
    }
  }
  
  private func alertView(type: AlertType) -> some View {
    PIDAlert(
      type: type,
      closeAction: { store.send(.alertCancelTapped) },
      acceptAction: { store.send(.alertAcceptTapped(type)) }
    )
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
            bloomingStatus: detailStore.bloomingStatus,
            spotCategory: detailStore.spotCategory,
            festivalInfo: detailStore.festivalInfo
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
  
  private func regionListSheet(with regionStore: StoreOf<SearchRegionListFeature>) -> some View {
    DetentBottomSheet(
      isPresented: $store.mapSearch.isShowRegionList,
      detent: $store.mapSearch.regionSheetDetent,
      currentHeight: $store.mapSearch.regionBottomSheetHeight
    ) {
      SearchRegionListView(store: regionStore)
    }
  }

  private func categoryListSheet(with categoryListStore: StoreOf<CategoryListFeature>) -> some View {
    DetentBottomSheet(
      isPresented: $store.category.isShowCategoryList,
      detent: $store.category.categoryListDetent,
      currentHeight: $store.category.categoryListBottomSheetHeight
    ) {
      CategoryListView(store: categoryListStore)
    }
  }
}



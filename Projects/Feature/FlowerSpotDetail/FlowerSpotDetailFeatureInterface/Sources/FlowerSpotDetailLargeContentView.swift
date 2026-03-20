//
//  FlowerSpotDetailLargeContentView.swift
//
//  FlowerSpotDetail
//
//  Created by 조용인
//

import SwiftUI
import Shared
import DesignKit
import ComposableArchitecture
import FlowerSpotClient

/// 바텀시트 확장 상태에서 보여줄 콘텐츠
public struct FlowerSpotDetailLargeContentView: View {
  @Bindable var store: StoreOf<FlowerSpotDetailFeature>

  /// 바텀시트 드래그 활성화 여부 (스크롤 ↔ 드래그 충돌 제어)
  @Binding var isDragEnabled: Bool

  /// 뒤로가기 버튼 탭 시 호출되는 콜백 (바텀시트 축소용)
  let onBackTapped: (() -> Void)?

  @State private var scrollOffset: CGPoint = .zero

  public init(
    store: StoreOf<FlowerSpotDetailFeature>,
    isDragEnabled: Binding<Bool>,
    onBackTapped: (() -> Void)? = nil
  ) {
    self.store = store
    self._isDragEnabled = isDragEnabled
    self.onBackTapped = onBackTapped
  }

  public var body: some View {
    ZStack {
      VStack(spacing: .Number0) {
        navigationBar
        mainScrollContent
        SpotDetailFloatingButton(store: store)
      }

      ToastView(message: $store.toastMessage)
        .padding(.bottom, .Number120)

      if store.isShowLoginAlert {
        PIDAlert(
          type: .login,
          closeAction: { store.send(.alertCancelTapped) },
          acceptAction: { store.send(.alertAcceptTapped) }
        )
      }

      if store.isPresentPhotoGallery {
        PhotoGalleryView(
          images: store.flowerSpotData.images,
          prefetchedImages: store.prefetchedImages,
          title: store.flowerSpotData.streetName,
          onImageTapped: { index in
            store.send(.presentPhotoViewer(index: index))
          },
          onBackTapped: {
            store.send(.popFromPhotoGallery)
          },
          onImageLoaded: { url, data in
            store.send(.cacheImage(url: url, data: data))
          }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, UIApplication.shared.safeAreaTopInset)
        .background(ColorSet.Background.Primary)
        .transition(.move(edge: .trailing))
      }
    }
    .animation(.easeInOut(duration: 0.25), value: store.isPresentPhotoGallery)
    .fullScreenCover(isPresented: $store.isPresentPhotoViewer, onDismiss: {
      store.send(.cleanupPhotoViewer)
    }) {
      if let viewer = store.photoViewer {
        PhotoViewerView(
          images: viewer.images,
          prefetchedImages: store.prefetchedImages,
          currentIndex: viewer.currentIndex,
          onDismiss: {
            store.send(.dismissPhotoViewer)
          },
          onPreviousTapped: {
            store.send(.photoViewerPreviousTapped)
          },
          onNextTapped: {
            store.send(.photoViewerNextTapped)
          },
          onImageLoaded: { url, data in
            store.send(.cacheImage(url: url, data: data))
          }
        )
      }
    }
    .onChange(of: scrollOffset) { _, newValue in
      // 스크롤이 최상단(offset.y <= 0)일 때만 바텀시트 드래그 허용
      isDragEnabled = newValue.y <= 0
    }
    .onAppear {
      store.send(.onAppear)
    }
  }

  // MARK: - Navigation Bar

  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .pullDown)
          .size(.superLarge)
          .action {
            onBackTapped?()
          }
      }
    )
    .padding(.top, UIApplication.shared.safeAreaTopInset)
  }

  // MARK: - Main Scroll Content

  @ViewBuilder
  private var mainScrollContent: some View {
    OffsetObservableScrollView(.vertical, scrollOffset: $scrollOffset) { _ in
      VStack(alignment: .leading, spacing: .Number0) {
        SpotDetailMainInfoSection(store: store)
        sectionDivider
        SpotDetailLocationSection(store: store)
        sectionDivider
        SpotDetailFlowerInfoSection(store: store)
      }
      .background(ScrollViewConfigurator(bounces: false))
    }
    .background(ColorSet.Background.Primary)
  }

  // MARK: - Section Divider

  private var sectionDivider: some View {
    Rectangle()
      .frame(height: .Number8)
      .foregroundStyle(ColorSet.Background.Tertiary)
  }
}

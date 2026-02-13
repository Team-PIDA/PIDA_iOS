//
//  FlowerSpotDetailFeature.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import Foundation
import ComposableArchitecture
import FlowerSpotClient
import BloomingClient
import DesignKit
import Shared
import AnalyticsClient

@Reducer
public struct FlowerSpotDetailFeature {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  // MARK: - PhotoViewer State

  public struct PhotoViewerState: Equatable {
    public var images: [FlowerSpotImageEntity]
    public var currentIndex: Int
    public var scale: CGFloat
    public var isUIHidden: Bool

    public init(images: [FlowerSpotImageEntity], currentIndex: Int) {
      self.images = images
      self.currentIndex = currentIndex
      self.scale = 1.0
      self.isUIHidden = false
    }
  }

  @ObservableState
  public struct State: Equatable {
    public var flowerSpotData: FlowerSpotEntity = .init(
      id: 0,
      recentlyVisitedCount: 0,
      bloomingStatus: "NOT_BLOOMED",
      streetName: "",
      path: [],
      pinPoint: .init(latitude: 0, longitude: 0),
      region: ""
    )
    public var bloomingStatus: BloomStatusEntity = .init(totalCount: 0, dayStatuses: [])
    public var distance: Double = .zero
    public var spotId: Int = 0
    public var toastMessage: String? = nil
    public var isNeedDrawPath: Bool = false
    public var isNeedDeletePath: Bool = false
    public var isShowLoginAlert: Bool = false
    public var isVotedBlooming: VerifyBloomingStateEntity = .init(isBlooming: false)
    public var isDetailLoading: Bool = false
    public var updateMarkerStatus: BloomStatus? = nil
    public var userLocation: Coordinate? = nil

    // MARK: - Navigation State

    public var isPresentPhotoGallery: Bool = false
    public var photoViewer: PhotoViewerState? = nil
    public var isPresentPhotoViewer: Bool = false

    // MARK: - Image Prefetch State

    /// URL -> Data 매핑 (프리페치된 이미지)
    public var prefetchedImages: [String: Data] = [:]

    /// 진입 경로 (Analytics 용)
    public var entryPoint: MapEvent.EntryPoint = .mapPin

    // MARK: - Analytics State

    /// 상세 페이지 진입 시간 (스크롤 시간 계산용)
    public var detailsStartTime: Date? = nil

    /// 주소 복사 횟수 (세션 내)
    public var copyAddressCount: Int = 0

    /// 하단 도달 이벤트 트래킹 여부
    public var hasTrackedScrollReachBottom: Bool = false

    public init(userLocation: Coordinate? = nil, entryPoint: MapEvent.EntryPoint = .mapPin) {
      self.userLocation = userLocation
      self.entryPoint = entryPoint
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case showToastView(message: String?)
    case showLoginAlert
    case checkAuth
    case onAppear

    case setFlowerSpotData(FlowerSpotEntity)
    case setBloomingStatus(BloomStatusEntity)
    case setDistance(Double)
    case setVerifyBloomingStatus(VerifyBloomingStateEntity)

    case alertCancelTapped
    case alertAcceptTapped

    /// 마커 탭, 검색 결과 선택 시 호출 (지도 위치 이동 안 함)
    case requestDetailInfo(Int)
    /// 딥링크, 외부 진입 시 호출 (지도 위치 이동 함)
    case fetchDetailInfo(Int)
    case detailResponse(FlowerSpotEntity, shouldUpdateMap: Bool)
    case bloomingResponse(BloomStatusEntity)
    case verifyTodayBlooming(VerifyBloomingStateEntity)

    // MARK: - Navigation (PhotoGallery)
    case pushToPhotoGallery
    case popFromPhotoGallery

    // MARK: - Presentation (PhotoViewer)
    case presentPhotoViewer(index: Int)
    case dismissPhotoViewer
    case cleanupPhotoViewer
    case photoViewerPreviousTapped
    case photoViewerNextTapped
    case photoViewerScaleChanged(CGFloat)

    // MARK: - Image Prefetch
    case prefetchImages
    case imagesPrefetched([String: Data])
    case cacheImage(url: String, data: Data)

    // MARK: - Analytics
    case copyAddressTapped
    case scrollReachedBottom

    // MARK: - Delegate
    case delegate(Delegate)
    case dismiss
    case presentToBlooming(id: Int, streetName: String, distance: Double?)
  }

  public enum Delegate: Equatable {
    case dismiss
    case presentToBlooming(id: Int, streetName: String, distance: Double?)
    case presentToLogin(id: Int)
    case showOnMap(FlowerSpotEntity)
    case didUpdateFlowerSpot(FlowerSpotEntity)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

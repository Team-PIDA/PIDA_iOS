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

@Reducer
public struct FlowerSpotDetailFeature {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  // MARK: - Path (내부 NavigationStack용)

  public enum Path: Hashable {
    case photoGallery
  }

  // MARK: - PhotoViewer State

  public struct PhotoViewerState: Equatable {
    public var imageUrls: [String]
    public var currentIndex: Int
    public var scale: CGFloat
    public var isUIHidden: Bool

    public init(imageUrls: [String], currentIndex: Int) {
      self.imageUrls = imageUrls
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

    public var path: [Path] = []
    public var photoViewer: PhotoViewerState? = nil
    public var isPresentPhotoViewer: Bool = false

    // MARK: - Image Prefetch State

    /// URL -> Data 매핑 (프리페치된 이미지)
    public var prefetchedImages: [String: Data] = [:]

    public init(userLocation: Coordinate? = nil) {
      self.userLocation = userLocation
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case showToastView(message: String?)
    case showLoginAlert
    case chechAuth
    case onAppear

    case setFlowerSpotData(FlowerSpotEntity)
    case setBloomingStatus(BloomStatusEntity)
    case setDistance(Double)
    case setVerifyBloomingStatus(VerifyBloomingStateEntity)

    case alertCancelTapped
    case alertAcceptTapped

    case requestDetailInfo(Int)
    case fetchDetailInfo(Int)
    case detailResponse(FlowerSpotEntity)
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

    // MARK: - Delegate
    case delegate(Delegate)
    case dismiss
    case presentToBlooming(id: Int, streetName: String)
  }

  public enum Delegate: Equatable {
    case dismiss
    case presentToBlooming(id: Int, streetName: String)
    case presentToLogin(id: Int)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

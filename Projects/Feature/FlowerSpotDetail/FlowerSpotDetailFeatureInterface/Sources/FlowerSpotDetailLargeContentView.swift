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
        floatingButton
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
        mainInfoSection
        sectionDivider
        locationSection
        sectionDivider
        flowerInfoSection
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

  // MARK: - Main Info Section

  @ViewBuilder
  private var mainInfoSection: some View {
    VStack(alignment: .leading, spacing: .Number14) {
      // 타이틀 + 서브 정보
      VStack(alignment: .leading, spacing: .Number6) {
        Text(store.spotTitle)
          .fontStyle(FontSet.Heading.heading1)
          .foregroundColor(ColorSet.Text.Primary)

        mainInfoSubtitle
      }

      Rectangle()
        .fill(ColorSet.Background.Tertiary)
        .frame(height: 1)

      // 카테고리별 정보 행
      mainInfoRows

      // Image Gallery (축제: 포스터 + 사진 / 그 외: 기존 갤러리)
      if store.spotCategory == .festival {
        FestivalImageGalleryView(
          posterImageURL: store.festivalInfo?.posterImageURL,
          images: store.flowerSpotData.images,
          prefetchedImages: store.prefetchedImages,
          onImageTapped: { index in
            store.send(.presentPhotoViewer(index: index))
          },
          onMoreTapped: {
            store.send(.pushToPhotoGallery)
          },
          onImageLoaded: { url, data in
            store.send(.cacheImage(url: url, data: data))
          }
        )
      } else {
        FlowerSpotImageGalleryView(
          images: store.flowerSpotData.images,
          prefetchedImages: store.prefetchedImages,
          onImageTapped: { index in
            store.send(.presentPhotoViewer(index: index))
          },
          onMoreTapped: {
            store.send(.pushToPhotoGallery)
          },
          onImageLoaded: { url, data in
            store.send(.cacheImage(url: url, data: data))
          }
        )
      }
    }
    .padding([.horizontal, .bottom], .Number16)
    .padding(.top, .Number8)
  }

  // MARK: - Main Info Subtitle (카테고리별 분기)

  @ViewBuilder
  private var mainInfoSubtitle: some View {
    switch store.spotCategory {
    case .festival:
      // 축제: 개화상태 + 홈페이지 링크
      HStack(spacing: .Number4) {
        bloomStatusBadge
        if store.festivalInfo?.homepageURL != nil {
          Text("·")
            .fontStyle(FontSet.Caption.caption1)
            .foregroundColor(ColorSet.Text.Secondary)
          HStack(spacing: .Number2) {
            Icon(image: .arrowOutward)
              .size(.small)
              .foregroundColor(ColorSet.Icon.Accent)
            Text("홈페이지")
              .fontStyle(FontSet.Caption.caption1)
              .foregroundColor(ColorSet.Text.Accent)
          }
        }
      }

    case .trail, .cafe:
      // 산책길/카페: 방문 횟수 + 개화상태
      HStack(spacing: .Number4) {
        Text(store.flowerSpotData.recentlyVisitedCountString)
          .fontStyle(FontSet.Label.label2)
          .foregroundColor(ColorSet.Text.Primary)
        Text("·")
          .fontStyle(FontSet.Caption.caption1)
          .foregroundColor(ColorSet.Text.Secondary)
        bloomStatusBadge
      }
    }
  }

  // MARK: - Bloom Status Badge (공통)

  @ViewBuilder
  private var bloomStatusBadge: some View {
    if let blooming = BloomStatus(rawValue: store.flowerSpotData.bloomingStatus) {
      HStack(spacing: .Number4) {
        GradiantIcon(image: .flower)
          .size(.large)
          .foregroundStyle(blooming.gradiant)
        Text(blooming.text)
          .fontStyle(FontSet.Label.label2)
          .foregroundColor(blooming.textColor)
      }
    }
  }

  // MARK: - Main Info Rows (카테고리별 분기)

  @ViewBuilder
  private var mainInfoRows: some View {
    VStack(alignment: .leading, spacing: .Number6) {
      // 거리 (공통)
      HStack(spacing: .Number4) {
        Icon(image: .distance)
          .size(.small)
          .foregroundColor(ColorSet.Icon.Secondary)
        Text(headerDistanceText)
          .fontStyle(FontSet.Body.body3)
          .foregroundColor(ColorSet.Text.Primary)
      }

      switch store.spotCategory {
      case .festival:
        // 축제: 날짜 범위
        if let festival = store.festivalInfo {
          HStack(spacing: .Number4) {
            Icon(image: .date)
              .size(.small)
              .foregroundColor(ColorSet.Icon.Secondary)
            Text("\(festival.startDate) ~ \(festival.endDate)")
              .fontStyle(FontSet.Body.body3)
              .foregroundColor(ColorSet.Text.Primary)
          }
        }

      case .trail:
        // 산책길: 나무 종류 + 소요시간/거리
        HStack(spacing: .Number4) {
          Icon(image: .forest)
            .size(.small)
            .foregroundColor(ColorSet.Icon.Secondary)
          Text(store.flowerSpotData.description)
            .fontStyle(FontSet.Body.body3)
            .foregroundColor(ColorSet.Text.Primary)
        }
        let walkingMinutes = max(1, Int((store.distance / 5.0) * 60))
        HStack(spacing: .Number4) {
          Icon(image: .steps)
            .size(.small)
            .foregroundColor(ColorSet.Icon.Secondary)
          Text("총 \(walkingMinutes)분 소요 · \(formattedDistance)")
            .fontStyle(FontSet.Body.body3)
            .foregroundColor(ColorSet.Text.Primary)
        }

      case .cafe:
        // 카페: 나무 종류 + 카테고리 + 웹사이트
        HStack(spacing: .Number4) {
          Icon(image: .forest)
            .size(.small)
            .foregroundColor(ColorSet.Icon.Secondary)
          Text(store.flowerSpotData.description)
            .fontStyle(FontSet.Body.body3)
            .foregroundColor(ColorSet.Text.Primary)
        }
        if let cafe = store.cafeInfo {
          HStack(spacing: .Number4) {
            Icon(image: .location)
              .size(.small)
              .foregroundColor(ColorSet.Icon.Secondary)
            Text(cafe.categoryLabel)
              .fontStyle(FontSet.Body.body3)
              .foregroundColor(ColorSet.Text.Primary)
          }
          if let websiteURL = cafe.websiteURL {
            HStack(spacing: .Number4) {
              Icon(image: .globe)
                .size(.small)
                .foregroundColor(ColorSet.Icon.Secondary)
              Text(websiteURL)
                .fontStyle(FontSet.Body.body3)
                .foregroundColor(ColorSet.Text.Accent)
                .underline()
            }
          }
        }
      }
    }
  }

  // MARK: - Location Section

  @ViewBuilder
  private var locationSection: some View {
    VStack(alignment: .leading, spacing: .Number14) {
      VStack(alignment: .leading, spacing: .Number8) {
        Text("위치")
          .fontStyle(FontSet.Heading.heading3)
          .foregroundColor(ColorSet.Text.Primary)

        HStack(spacing: .Number4) {
          Text(store.flowerSpotData.address)
            .fontStyle(FontSet.Body.body2)
            .foregroundColor(ColorSet.Text.Primary)

          HStack(spacing: .Number0) {
            Icon(image: .copy)
              .size(.small)
              .foregroundColor(ColorSet.Icon.Accent)
            Text("복사")
              .fontStyle(FontSet.Caption.caption1)
              .foregroundColor(ColorSet.Text.Accent)
          }
          .onTapGesture {
            UIPasteboard.general.string = store.flowerSpotData.address
            store.send(.copyAddressTapped)
            store.send(.showToastView(message: "주소가 복사되었습니다."))
          }
        }

        // 도보 시간 (산책길/카페만)
        if store.showsWalkingTime {
          Text(walkingTimeText)
            .fontStyle(FontSet.Title.title4)
            .foregroundColor(ColorSet.Text.Accent)
        }
      }

      // Mini Map
      if let blooming = BloomStatus(rawValue: store.flowerSpotData.bloomingStatus) {
        DetailMapViewRepresentable(
          location: store.flowerSpotData.pinPoint,
          pathMarkers: store.flowerSpotData.path,
          state: blooming,
          isNeedDrawPath: $store.isNeedDrawPath,
          isNeedDeletePath: $store.isNeedDeletePath
        )
        .frame(height: 160)
        .cornerRadius(10)
      }

      // 제보자 배너 (산책길만)
      if store.showsInformantBanner,
         let nickname = store.bloomingStatus.nickname,
         let updateAt = store.bloomingStatus.updatedAt {
        HStack(spacing: .Number8) {
          Icon(image: .verified)
            .size(.extremeLarge)
            .foregroundColor(ColorSet.Icon.Accent)

          VStack(alignment: .leading, spacing: .Number2) {
            (Text(nickname)
              .foregroundColor(ColorSet.Text.Accent) +
             Text("님이 제보해준 길이에요")
              .foregroundColor(ColorSet.Text.Primary))
            .fontStyle(FontSet.Title.title4)
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("\(updateAt) 업데이트")
              .fontStyle(FontSet.Caption.caption1)
              .foregroundColor(ColorSet.Text.Secondary)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
        .padding(.Number12)
        .background(ColorSet.Background.Secondary)
        .cornerRadius(.Number10)
      }
    }
    .padding(.Number16)
  }

  // MARK: - Flower Info Section

  @ViewBuilder
  private var flowerInfoSection: some View {
    VStack(alignment: .leading, spacing: .Number28) {
      // 나무 종류 (산책길/카페만)
      if store.showsTreeTypeSection {
        VStack(alignment: .leading, spacing: .Number8) {
          Text("나무 종류")
            .fontStyle(FontSet.Heading.heading3)
            .foregroundColor(ColorSet.Text.Primary)
            .onAppear {
              store.send(.scrollReachedBottom)
            }

          Text(store.flowerSpotData.description)
            .fontStyle(FontSet.Body.body2)
            .foregroundColor(ColorSet.Text.Primary)
        }
      }

      // 개화 상태 (공통)
      VStack(alignment: .leading, spacing: .Number12) {
        VStack(alignment: .leading, spacing: .Number8) {
          Text("개화 상태")
            .fontStyle(FontSet.Heading.heading3)
            .foregroundColor(ColorSet.Text.Primary)
            .onAppear {
              // 축제의 경우 나무 종류 섹션이 없으므로 여기서 트래킹
              if !store.showsTreeTypeSection {
                store.send(.scrollReachedBottom)
              }
            }

          Text("최근 5일 동안 \(store.bloomingStatus.totalCount)명이 기록했어요")
            .fontStyle(FontSet.Body.body2)
            .foregroundColor(ColorSet.Text.Primary)
        }

        LazyVStack(alignment: .leading, spacing: .Number6) {
          ForEach(store.bloomingStatus.dayStatuses, id: \.id) { status in
            BloomStatusGraph(
              date: status.date,
              little: status.little.percentage,
              bloomed: status.bloomed.percentage,
              withered: status.withered.percentage,
              maxVoteCount: status.maxValue
            )
          }
        }
      }
    }
    .padding(.Number16)
  }

  // MARK: - Floating Button

  @ViewBuilder
  private var floatingButton: some View {
    VStack(spacing: .Number0) {
      PIDButton(
        title: "오늘의 개화 상태 기록하기",
        size: .large
      )
      .action {
        store.send(.checkAuth)
      }
      .isActive(!store.isVotedBlooming.isBlooming)
      .padding(.horizontal, .Number16)
      .padding(.vertical, .Number16)
      .padding(.bottom, UIApplication.shared.safeAreaBottomInset)
    }
    .background(
      Color.white
        .shadow(color: .black.opacity(0.16), radius: 8)
    )
  }

  // MARK: - Distance Formatting

  private var formattedDistance: String {
    if store.distance < 1.0 {
      return "\(Int(store.distance * 1000))m"
    } else {
      return String(format: "%.1f", store.distance) + "km"
    }
  }

  private var headerDistanceText: String {
    if store.distance < 1.0 {
      return "내 위치로부터 \(formattedDistance)이내"
    } else {
      return "내 위치로부터 \(formattedDistance)"
    }
  }

  private var walkingTimeText: String {
    let walkingMinutes = max(1, Int((store.distance / 5.0) * 60))
    if store.distance < 1.0 {
      return "현재 위치에서 걸어서 \(walkingMinutes)분 (\(formattedDistance) 이내)"
    } else {
      return "현재 위치에서 걸어서 \(walkingMinutes)분 (\(formattedDistance))"
    }
  }
}

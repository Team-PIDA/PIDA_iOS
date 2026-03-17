//
//  FlowerSpotDetailView.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import SwiftUI
import Shared
import DesignKit
import ComposableArchitecture
import FlowerSpotClient

public struct FlowerSpotDetailView: View {
  @Bindable var store: StoreOf<FlowerSpotDetailFeature>
  @State private var offsetY: CGPoint = .zero
  
  @State var isNeedDrawPath: Bool = true
  @State var isNeedDeletePath: Bool = false
  
  public init(store: StoreOf<FlowerSpotDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      VStack(spacing: .Number0) {
        navigationBar
        mainScrollContent
        floatingButton
      }
      ToastView(message: $store.toastMessage)
        .padding(.bottom, .Number80)
      if store.isShowLoginAlert {
        PIDAlert(
          type: .login,
          closeAction: { store.send(.alertCancelTapped) },
          acceptAction: { store.send(.alertAcceptTapped) }
        )
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .pullDown)
          .size(.superLarge)
          .action {
            return await MainActor.run {
              store.send(.dismiss)
            }
          }
      },
      title: offsetY.y > 36 ? store.flowerSpotData.streetName : ""
    )
  }
  
  @ViewBuilder
  private var mainScrollContent: some View {
    OffsetObservableScrollView(.vertical, scrollOffset: $offsetY) { _ in
      VStack(alignment: .leading, spacing: .Number0) {
        mainInfoSection
        Rectangle()
          .frame(height: .Number8)
          .foregroundStyle(ColorSet.Background.Tertiary)
        locationSection
        Rectangle()
          .frame(height: .Number8)
          .foregroundStyle(ColorSet.Background.Tertiary)
        flowerInfoSection
      }
    }
    .background(ColorSet.Background.Primary)
  }
  
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
      Divider()
        .background(ColorSet.Border.Secondary)
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

  @ViewBuilder
  private var mainInfoSubtitle: some View {
    switch store.spotCategory {
    case .festival:
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

  @ViewBuilder
  private var mainInfoRows: some View {
    VStack(alignment: .leading, spacing: .Number6) {
      HStack(spacing: .Number4) {
        Icon(image: .distance)
          .size(.small)
          .foregroundColor(ColorSet.Icon.Secondary)
        Text("내 위치로부터 " + "\(store.distance) km")
          .fontStyle(FontSet.Body.body3)
          .foregroundColor(ColorSet.Text.Primary)
      }

      switch store.spotCategory {
      case .festival:
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
        HStack(spacing: .Number4) {
          Icon(image: .forest)
            .size(.small)
            .foregroundColor(ColorSet.Icon.Secondary)
          Text(store.flowerSpotData.description)
            .fontStyle(FontSet.Body.body3)
            .foregroundColor(ColorSet.Text.Primary)
        }

      case .cafe:
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
  
  @ViewBuilder
  private var locationSection: some View {
    VStack(alignment: .leading, spacing: .Number14) {
      VStack(alignment: .leading, spacing: .Number8) {
        Text("위치")
          .fontStyle(FontSet.Heading.heading2)
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
          let walkingMinutes = max(1, Int((store.distance / 5.0) * 60))
          Text("현재 위치에서 걸어서 약 \(walkingMinutes)분 (\(String(format: "%.1f", store.distance))km)")
            .fontStyle(FontSet.Title.title4)
            .foregroundColor(ColorSet.Text.Accent)
        }
      }
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
  
  @ViewBuilder
  private var floatingButton: some View {
    ZStack(alignment: .bottom) {
      Rectangle()
        .fill(.white)
        .shadow(color: .black.opacity(0.16), radius: 8)
        .ignoresSafeArea()
      PIDButton(
        title: "오늘의 개화 상태 기록하기",
        size: .large
      )
      .action {
        print("오늘의 개화 상태 기록하기")
        store.send(.checkAuth)
      }
      .isActive(!store.isVotedBlooming.isBlooming)
      .padding(.Number16)
    }
    .frame(height: 80)
    .background(Color.white)
  }
}

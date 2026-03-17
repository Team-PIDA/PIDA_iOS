//
//  FlowerSpotDetailDemoApp.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import FlowerSpotDetailFeatureInterface
import FlowerSpotClient
import BloomingClient
import Shared

// MARK: - Sample Images (Unsplash)

private enum SampleImage {
  static let cherryBlossom1 = "https://images.unsplash.com/photo-1522383225653-ed111181a951?w=400&h=400&fit=crop"
  static let cherryBlossom2 = "https://images.unsplash.com/photo-1462275646964-a0e3c11f18a6?w=400&h=400&fit=crop"
  static let cherryBlossom3 = "https://images.unsplash.com/photo-1588286840104-8957b019727f?w=400&h=400&fit=crop"
  static let cherryBlossom4 = "https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=400&h=400&fit=crop"
  static let festival = "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&h=600&fit=crop"
  static let cafe = "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&h=400&fit=crop"
}

// MARK: - Mock Data

enum MockData {
  static func trailState() -> FlowerSpotDetailFeature.State {
    var state = FlowerSpotDetailFeature.State(
      spotCategory: .trail
    )
    state.flowerSpotData = FlowerSpotEntity(
      id: 1,
      address: "서울 송파구 송파나루길 256 문화공간 호수",
      recentlyVisitedCount: 3,
      bloomingStatus: "BLOOMED",
      streetName: "석촌호수길",
      district: "송파구",
      description: "왕벚꽃나무",
      path: [],
      pinPoint: .init(latitude: 37.5085, longitude: 127.1050),
      region: "서울",
      images: [
        .init(url: SampleImage.cherryBlossom1, createdAt: Date()),
        .init(url: SampleImage.cherryBlossom2, createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())),
        .init(url: SampleImage.cherryBlossom3, createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date())),
        .init(url: SampleImage.cherryBlossom4, createdAt: Calendar.current.date(byAdding: .day, value: -5, to: Date())),
      ]
    )
    state.bloomingStatus = mockBloomStatus(nickname: "벚꽃러버")
    state.distance = 0.05
    return state
  }

  static func festivalState() -> FlowerSpotDetailFeature.State {
    var state = FlowerSpotDetailFeature.State(
      spotCategory: .festival,
      festivalInfo: FestivalInfoEntity(
        startDate: "2025.04.08(화)",
        endDate: "2025.04.12(토)",
        homepageURL: "https://example.com",
        posterImageURL: SampleImage.festival
      )
    )
    state.flowerSpotData = FlowerSpotEntity(
      id: 2,
      address: "강원도 속초 영랑호 잔디광장",
      recentlyVisitedCount: 0,
      bloomingStatus: "BLOOMED",
      streetName: "무브살롱 시즌4 벚꽃 아틀리에",
      district: "속초시",
      description: "",
      path: [],
      pinPoint: .init(latitude: 38.2070, longitude: 128.5918),
      region: "강원",
      images: [
        .init(url: SampleImage.festival, createdAt: Date()),
        .init(url: SampleImage.cherryBlossom1, createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())),
        .init(url: SampleImage.cherryBlossom2, createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())),
        .init(url: SampleImage.cherryBlossom3, createdAt: Calendar.current.date(byAdding: .day, value: -4, to: Date())),
      ]
    )
    state.bloomingStatus = mockBloomStatus(nickname: nil)
    state.distance = 0.05
    return state
  }

  static func cafeState() -> FlowerSpotDetailFeature.State {
    var state = FlowerSpotDetailFeature.State(
      spotCategory: .cafe,
      cafeInfo: CafeInfoEntity(
        categoryLabel: "카페",
        websiteURL: "www.pida.com"
      )
    )
    state.flowerSpotData = FlowerSpotEntity(
      id: 3,
      address: "서울 송파구 송파나루길 256 문화공간 호수",
      recentlyVisitedCount: 5,
      bloomingStatus: "BLOOMED",
      streetName: "000카페",
      district: "송파구",
      description: "왕벚꽃나무",
      path: [],
      pinPoint: .init(latitude: 37.5085, longitude: 127.1050),
      region: "서울",
      images: [
        .init(url: SampleImage.cafe, createdAt: Date()),
        .init(url: SampleImage.cherryBlossom1, createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())),
        .init(url: SampleImage.cherryBlossom4, createdAt: Calendar.current.date(byAdding: .day, value: -5, to: Date())),
      ]
    )
    state.bloomingStatus = mockBloomStatus(nickname: nil)
    state.distance = 0.05
    return state
  }

  static func mockBloomStatus(nickname: String?) -> BloomStatusEntity {
    let calendar = Calendar.current
    let today = Date()
    let dates: [String] = (0..<5).map { i in
      let date = calendar.date(byAdding: .day, value: -i, to: today)!
      return date.toString(format: .yearMonthDay)
    }

    let statuses: [DayStatus] = dates.enumerated().map { i, dateStr in
      if i == 0 {
        // 오늘: 데이터 없음
        return DayStatus(
          date: dateStr,
          bloomed: nil,
          withered: nil,
          little: nil
        )
      } else {
        return DayStatus(
          date: dateStr,
          bloomed: .init(peopleCount: max(1, 4 - i), percentage: max(10, 60 - i * 12)),
          withered: .init(peopleCount: i, percentage: min(60, i * 15)),
          little: .init(peopleCount: max(0, 3 - i), percentage: max(0, 30 - i * 8))
        )
      }
    }

    return BloomStatusEntity(
      totalCount: 12,
      nickname: nickname,
      updatedAt: nickname != nil ? "2일 전" : nil,
      dayStatuses: statuses
    )
  }
}

// MARK: - No-op Reducer

private let noopReducer = Reduce<FlowerSpotDetailFeature.State, FlowerSpotDetailFeature.Action> { _, _ in
  .none
}

// MARK: - App

@main
struct FlowerSpotDetailDemoApp: App {
  var body: some Scene {
    WindowGroup {
      DemoCategoryTabView()
    }
  }
}

// MARK: - Tab View

struct DemoCategoryTabView: View {
  @State private var selectedTab: SpotCategory = .trail

  var body: some View {
    VStack(spacing: 0) {
      categoryTabBar
      selectedCategoryView
    }
  }

  private var categoryTabBar: some View {
    HStack(spacing: 0) {
      tabButton(title: "산책길", category: .trail)
      tabButton(title: "축제", category: .festival)
      tabButton(title: "카페", category: .cafe)
    }
    .padding(.top, 4)
  }

  @ViewBuilder
  private var selectedCategoryView: some View {
    switch selectedTab {
    case .trail:
      trailView
    case .festival:
      festivalView
    case .cafe:
      cafeView
    }
  }

  private var trailView: some View {
    FlowerSpotDetailLargeContentView(
      store: Store(
        initialState: MockData.trailState()
      ) {
        FlowerSpotDetailFeature(reducer: noopReducer)
      },
      isDragEnabled: .constant(true)
    )
  }

  private var festivalView: some View {
    FlowerSpotDetailLargeContentView(
      store: Store(
        initialState: MockData.festivalState()
      ) {
        FlowerSpotDetailFeature(reducer: noopReducer)
      },
      isDragEnabled: .constant(true)
    )
  }

  private var cafeView: some View {
    FlowerSpotDetailLargeContentView(
      store: Store(
        initialState: MockData.cafeState()
      ) {
        FlowerSpotDetailFeature(reducer: noopReducer)
      },
      isDragEnabled: .constant(true)
    )
  }

  private func tabButton(title: String, category: SpotCategory) -> some View {
    Button {
      selectedTab = category
    } label: {
      Text(title)
        .font(.system(size: 14, weight: selectedTab == category ? .bold : .medium))
        .foregroundColor(selectedTab == category ? .white : .gray)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(selectedTab == category ? Color.teal : Color.clear)
        .cornerRadius(8)
    }
    .padding(.horizontal, 4)
  }
}

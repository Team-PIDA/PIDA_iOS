//
//  FlowerSpotDetailView.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import FlowerSpotDomainInterface

public struct FlowerSpotDetailView: View {
  @Bindable var store: StoreOf<FlowerSpotDetailReducer>
  @State private var offsetY: CGPoint = .zero
  
  @State var isNeedDrawPath: Bool = true
  @State var isNeedDeletePath: Bool = false
  private var location: MapPoint = .init(latitude: 37.5464, longitude: 126.91923)
  private var coord: [MapPoint] = [
    .init(latitude: 37.54542, longitude: 126.91869),
    .init(latitude: 37.54783, longitude: 126.91993)
  ]
  
  public init(store: StoreOf<FlowerSpotDetailReducer>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: .Number0) {
      navigationBar
      mainScrollContent
      floatingButton
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
      title: offsetY.y > 36 ? "석촌호수길" : ""
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
      VStack(alignment: .leading, spacing: .Number6) {
        Text("석촌호수길")
          .fontStyle(FontSet.Heading.heading1)
          .foregroundColor(ColorSet.Text.Primary)
        HStack(spacing: .Number4) {
          Text("최근 방문 0회")
            .fontStyle(FontSet.Label.label2)
            .foregroundColor(ColorSet.Text.Primary)
          Text("·")
            .fontStyle(FontSet.Label.label2)
            .foregroundColor(ColorSet.Text.Secondary)
          HStack(spacing: .Number4) {
            GradiantIcon(image: .flower)
              .size(.large)
              .foregroundStyle(ColorSet.GradiantSet.gra1)
            Text("만개에요!")
              .fontStyle(FontSet.Label.label2)
              .foregroundColor(ColorSet.Pink._400)
          }
        }
      }
      Divider()
        .background(ColorSet.Border.Secondary)
      VStack(alignment: .leading, spacing: .Number6) {
        HStack(spacing: .Number4) {
          Icon(image: .distance)
            .size(.small)
            .foregroundColor(ColorSet.Icon.Secondary)
          Text("내 위치로부터 50m이내")
            .fontStyle(FontSet.Body.body3)
            .foregroundColor(ColorSet.Text.Primary)
        }
        HStack(spacing: 4) {
          Icon(image: .location)
            .size(.small)
            .foregroundColor(ColorSet.Icon.Secondary)
          Text("최근 방문 0회")
            .fontStyle(FontSet.Body.body3)
            .foregroundColor(ColorSet.Text.Primary)
        }
      }
    }
    .padding([.horizontal, .bottom], .Number16)
    .padding(.top, .Number8)
  }
  
  @ViewBuilder
  private var locationSection: some View {
    VStack(alignment: .leading, spacing: .Number14) {
      VStack(alignment: .leading, spacing: .Number8) {
        Text("위치")
          .fontStyle(FontSet.Heading.heading2)
          .foregroundColor(ColorSet.Text.Primary)
        HStack(spacing: .Number4) {
          Text("서울 송파구 송파나루길 256 문화공간 호수")
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
            print("주소 복사")
          }
        }
        Text("현재 위치에서 걸어서 5분 (50m 이내)")
          .fontStyle(FontSet.Title.title4)
          .foregroundColor(ColorSet.Text.Accent)
      }
      // TODO: 실제 지도 영역
      // reducer의 데이터와 연결해야 함!
//            if let data = store.flowerSpotData {
//              DetailMapViewRepresentable(
//                location: data.pinPoint,
//                pathMarkers: data.path,
//                state: data.bloomingStatus,
//                isNeedDrawPath: $store.isNeedDrawPath,
//                isNeedDeletePath: $store.isNeedDeletePath
//              )
//              .frame(height: 160)
//              .cornerRadius(10)
//            }
      DetailMapViewRepresentable(
        location: location,
        pathMarkers: coord,
        state: .little,
        isNeedDrawPath: $isNeedDrawPath,
        isNeedDeletePath: $isNeedDeletePath
      )
      .frame(height: 160)
      .cornerRadius(10)
    }
    .padding(.Number16)
  }
  
  @ViewBuilder
  private var flowerInfoSection: some View {
    VStack(alignment: .leading, spacing: .Number28) {
      VStack(alignment: .leading, spacing: .Number8) {
        Text("꽃 정보")
          .fontStyle(FontSet.Heading.heading3)
          .foregroundColor(ColorSet.Text.Primary)
        
        Text("겹벚꽃")
          .fontStyle(FontSet.Body.body2)
          .foregroundColor(ColorSet.Text.Primary)
      }
      VStack(alignment: .leading, spacing: .Number12) {
        VStack(alignment: .leading, spacing: .Number8) {
          Text("개화 상태")
            .fontStyle(FontSet.Heading.heading3)
            .foregroundColor(ColorSet.Text.Primary)
          Text("최근 5일 동안 {N}명이 기록했어요")
            .fontStyle(FontSet.Body.body2)
            .foregroundColor(ColorSet.Text.Primary)
        }
        VStack(alignment: .leading, spacing: 6) {
          BloomStatusGraph(date: "2025-04-02", little: 10, bloomed: 20, withered: 70, maxVoteCount: 10)
          BloomStatusGraph(date: "2025-04-01", little: 60, bloomed: 10, withered: 30, maxVoteCount: 10)
          BloomStatusGraph(date: "2025-03-31", little: 20, bloomed: 60, withered: 20, maxVoteCount: 10)
          BloomStatusGraph(date: "2025-03-30", little: 20, bloomed: 40, withered: 40, maxVoteCount: 10)
          BloomStatusGraph(date: "2025-03-29", little: 0, bloomed: 0, withered: 0, maxVoteCount: 0)
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
      }
      .padding(.Number16)
    }
    .frame(height: 80)
    .background(Color.white)
//    .onAppear {
//      store.send(.onAppear)
//    }
  }
}

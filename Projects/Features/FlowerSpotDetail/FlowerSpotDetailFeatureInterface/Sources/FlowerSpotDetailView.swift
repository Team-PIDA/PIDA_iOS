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
  
  public init(store: StoreOf<FlowerSpotDetailReducer>) {
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
      VStack(alignment: .leading, spacing: .Number6) {
        Text(store.flowerSpotData.streetName)
          .fontStyle(FontSet.Heading.heading1)
          .foregroundColor(ColorSet.Text.Primary)
        HStack(spacing: .Number4) {
          Text(store.flowerSpotData.recentlyVisitedCountString)
            .fontStyle(FontSet.Label.label2)
            .foregroundColor(ColorSet.Text.Primary)
          Text("·")
            .fontStyle(FontSet.Label.label2)
            .foregroundColor(ColorSet.Text.Secondary)
          HStack(spacing: .Number4) {
            GradiantIcon(image: .flower)
              .size(.large)
              .foregroundStyle(store.flowerSpotData.bloomingStatus.gradiant)
            Text(store.flowerSpotData.bloomingStatus.text)
              .fontStyle(FontSet.Label.label2)
              .foregroundColor(store.flowerSpotData.bloomingStatus.textColor)
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
          Text("내 위치로부터 {INT}km")
            .fontStyle(FontSet.Body.body3)
            .foregroundColor(ColorSet.Text.Primary)
        }
        HStack(spacing: 4) {
          Icon(image: .location)
            .size(.small)
            .foregroundColor(ColorSet.Icon.Secondary)
          Text(store.flowerSpotData.recentlyVisitedCountString)
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
            store.send(.showToastView(message: "주소가 복사되었습니다."))
          }
        }
        Text("현재 위치에서 걸어서 5분 ({}km)")
          .fontStyle(FontSet.Title.title4)
          .foregroundColor(ColorSet.Text.Accent)
      }
      DetailMapViewRepresentable(
        location: store.flowerSpotData.pinPoint,
        pathMarkers: store.flowerSpotData.path,
        state: store.flowerSpotData.bloomingStatus,
        isNeedDrawPath: $store.isNeedDrawPath,
        isNeedDeletePath: $store.isNeedDeletePath
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
        
        Text(store.flowerSpotData.description)
          .fontStyle(FontSet.Body.body2)
          .foregroundColor(ColorSet.Text.Primary)
      }
      VStack(alignment: .leading, spacing: .Number12) {
        VStack(alignment: .leading, spacing: .Number8) {
          Text("개화 상태")
            .fontStyle(FontSet.Heading.heading3)
            .foregroundColor(ColorSet.Text.Primary)
          Text("최근 5일 동안 \(store.bloomingStatus.totalCount)명이 기록했어요")
            .fontStyle(FontSet.Body.body2)
            .foregroundColor(ColorSet.Text.Primary)
        }
        LazyVStack(alignment: .leading, spacing: 6) {
          ForEach(store.bloomingStatus.dayStatuses, id: \.id) { status in
            BloomStatusGraph(
              date: status.date,
              little: status.little.percentage,
              bloomed: status.bloomed.percentage,
              withered: status.bloomed.percentage,
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
        store.send(.presentToBlooming(streetName: store.flowerSpotData.streetName))
      }
      .padding(.Number16)
    }
    .frame(height: 80)
    .background(Color.white)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

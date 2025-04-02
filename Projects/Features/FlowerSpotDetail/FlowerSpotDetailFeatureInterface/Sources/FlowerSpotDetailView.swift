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

public struct FlowerSpotDetailView: View {
  let store: StoreOf<FlowerSpotDetailReducer>

  public init(store: StoreOf<FlowerSpotDetailReducer>) {
    self.store = store
  }

  public var body: some View {
    ContentView()
  }
}

public struct ContentView: View {
  public var body: some View {
    ZStack(alignment: .bottom) {
      // 메인 스크롤 컨텐츠
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          // ---------------------
          // MARK: - 1번 섹션
          VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
              // TODO: 외부데이터 - 거리명
              Text("석촌호수길")
                .fontStyle(FontSet.Heading.heading1)
                .foregroundColor(ColorSet.Text.Primary)
              HStack(spacing: 4) {
                // TODO: 외부데이터 - 방문 횟수
                Text("최근 방문 0회")
                  .fontStyle(FontSet.Label.label2)
                  .foregroundColor(ColorSet.Text.Primary)
                Text("·")
                  .fontStyle(FontSet.Label.label2)
                  .foregroundColor(ColorSet.Text.Secondary)
                HStack(spacing: 4) {
                  // TODO: 외부데이터 - 개화 상태
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
            VStack(alignment: .leading, spacing: 6) {
              HStack(spacing: 4) {
                Icon(image: .distance)
                  .size(.small)
                  .foregroundColor(ColorSet.Icon.Secondary)
                // TODO: 외부데이터 - 거리
                Text("내 위치로부터 50m이내")
                  .fontStyle(FontSet.Body.body3)
                  .foregroundColor(ColorSet.Text.Primary)
              }
              HStack(spacing: 4) {
                Icon(image: .location)
                  .size(.small)
                  .foregroundColor(ColorSet.Icon.Secondary)
                // TODO: 외부데이터 - 최근 방문 횟수
                Text("최근 방문 0회")
                  .fontStyle(FontSet.Body.body3)
                  .foregroundColor(ColorSet.Text.Primary)
              }
            }
          }
          .padding([.horizontal, .bottom], 16)
          .padding(.top, 8)
          Rectangle()
            .frame(height: 8)
            .foregroundStyle(ColorSet.Background.Tertiary)
          // ---------------------
          // MARK: - 2번 섹션
          VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
              Text("위치")
                .fontStyle(FontSet.Heading.heading2)
                .foregroundColor(ColorSet.Text.Primary)
              HStack(spacing: 4) {
                // TODO: 외부데이터 - 주소
                Text("서울 송파구 송파나루길 256 문화공간 호수")
                  .fontStyle(FontSet.Body.body2)
                  .foregroundColor(ColorSet.Text.Primary)
                HStack(spacing: 0) {
                  Icon(image: .copy)
                    .size(.small)
                    .foregroundColor(ColorSet.Icon.Accent)
                  Text("복사")
                    .fontStyle(FontSet.Caption.caption1)
                    .foregroundColor(ColorSet.Text.Accent)
                }
                .onTapGesture {
                  // TODO: 주소 복사 토스트 & 클립보드 복사
                  print("주소 복사")
                }
              }
              // TODO: 외부데이터 - 거리, 시간 계산
              Text("현재 위치에서 걸어서 5분 (50m 이내)")
                .fontStyle(FontSet.Title.title4)
                .foregroundColor(ColorSet.Text.Accent)
            }
            
            // TODO: 실제 지도 영역
            Rectangle()
              .fill(ColorSet.Text.Primary)
              .frame(height: 160)
              .cornerRadius(10)
          }
          .padding(16)
          Rectangle()
            .frame(height: 8)
            .foregroundStyle(ColorSet.Background.Tertiary)
          // ---------------------
          // MARK: - 3번 섹션
          VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 8) {
              Text("꽃 정보")
                .fontStyle(FontSet.Heading.heading3)
                .foregroundColor(ColorSet.Text.Primary)
              
              Text("겹벚꽃")
                .fontStyle(FontSet.Body.body2)
                .foregroundColor(ColorSet.Text.Primary)
            }
            VStack(alignment: .leading, spacing: 12) {
              VStack(alignment: .leading, spacing: 8) {
                Text("개화 상태")
                  .fontStyle(FontSet.Heading.heading3)
                  .foregroundColor(ColorSet.Text.Primary)
                // TODO: 외부데이터 - 기록 인원 수
                Text("최근 5일 동안 {N}명이 기록했어요")
                  .fontStyle(FontSet.Body.body2)
                  .foregroundColor(ColorSet.Text.Primary)
              }
              VStack(alignment: .leading, spacing: 6) {
                // TODO: - DesignKit에 만들어 질, 개화상태 Cell을 LazyStack으로 구현
              }
            }
          }
          .padding(16)
        }
      }
      // 플로팅 버튼 영역
      VStack(spacing: 0) {
        Divider()
          .background(ColorSet.Gray._200)
        
        ZStack {
          Rectangle()
            .fill(.white)
            .shadow(color: .black.opacity(0.16), radius: 8)
            .ignoresSafeArea()
          PIDButton(
            title: "오늘의 개화 상태 기록하기",
            size: .large
          ) {
            // TODO: 개화 상태 기록하기 -> 로그인 유도,,,
          }
          .padding(16)
        }
        .frame(height: 80) // 버튼 높이(48) + 상하 패딩(16+16)
      }
      .background(Color.white)
    }
  }
}

#Preview {
  ContentView()
}

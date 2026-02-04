//
//  BloomingUpdateView.swift
//  BloomingFeatureInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import PhotosUI
import DotLottie
import DesignKit
import ComposableArchitecture

public struct BloomingUpdateView: View {
  @Bindable var store: StoreOf<BloomingUpdateFeature>
  @State private var photosPickerItem: PhotosPickerItem? = nil

  public init(store: StoreOf<BloomingUpdateFeature>) {
    self.store = store
  }
  
  public var body: some View {
    if store.isCompleted {
      completionView
    } else {
      inputView
    }
  }

  // MARK: - Completion View

  @ViewBuilder
  private var completionView: some View {
    ZStack {
      ColorSet.Background.Accent
        .ignoresSafeArea()

      VStack(spacing: .Number0) {
        Spacer()

        DotLottieAnimation(
          fileName: LottieSet.update_success_panpare.name,
          config: AnimationConfig(autoplay: true, loop: false)
        )
        .view()
        .frame(width: .Number120, height: .Number120)

        Spacer()
          .frame(height: .Number24)

        ImageSet.updateCompletedIcon.swiftUIImage.swiftUIImage
          .resizable()
          .frame(width: .Number48, height: .Number48)

        Spacer()
          .frame(height: .Number16)

        VStack(spacing: .Number8) {
          Text("개화 상태를\n기록했어요")
            .fontStyle(FontSet.Heading.heading1)
            .foregroundStyle(ColorSet.Text.Primary)
            .multilineTextAlignment(.center)

          Text("\(store.streetName)의 개화 상태가 기록되었어요")
            .fontStyle(FontSet.Body.body3)
            .foregroundStyle(ColorSet.Text.Secondary)
        }

        Spacer()

        PIDButton(title: "상세페이지로 돌아가기", size: .large)
          .action {
            guard let spotId = store.spotId else { return }
            store.send(.dismiss(didUpdate: true, spotId: spotId))
          }
          .padding(.Number16)
      }
    }
  }

  // MARK: - Input View

  @ViewBuilder
  private var inputView: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      ZStack {
        VStack(spacing: .Number0) {
          navigationBar
          Spacer()
            .frame(height: .Number54)
          VStack(spacing: .Number48) {
            mainTitle
            StateRadioButton(status: $store.selectedStatus)
          }
          Spacer()
            .frame(height: .Number32)
          Rectangle()
            .fill(ColorSet.Background.Secondary)
            .frame(height: .Number2)
            .padding(.horizontal, .Number16)
          Spacer()
            .frame(height: .Number32)
          photoSection
          Spacer()
          saveButton
        }
        ToastView(message: $store.toastMessage)
      }
    }
    .photosPicker(
      isPresented: $store.isPhotoPickerPresented,
      selection: $photosPickerItem,
      matching: .images
    )
    .onChange(of: photosPickerItem) { _, newItem in
      Task {
        if let data = try? await newItem?.loadTransferable(type: Data.self) {
          store.send(.photoSelected(data))
        }
      }
    }
    .onChange(of: store.selectedImageData) { _, newValue in
      if newValue == nil {
        photosPickerItem = nil
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      closeContent:  {
      TouchArea(image: .close)
        .size(.superLarge)
        .action {
          guard let spotId = store.spotId else { return }
          store.send(.dismiss(didUpdate: false, spotId: spotId))
        }
      }
    )
  }
  
  
  @ViewBuilder
  private var mainTitle: some View {
    VStack(alignment: .center, spacing: .Number8) {
      VStack(alignment: .center, spacing: .Number0) {
        Text("오늘 방문한")
          .foregroundStyle(ColorSet.Text.Primary)
        HStack(spacing: .Number0) {
          Text(store.streetName)
            .foregroundStyle(ColorSet.Text.Accent)
          Text("의")
            .foregroundStyle(ColorSet.Text.Primary)
        }
        Text("개화상태는 어땠나요?")
          .foregroundStyle(ColorSet.Text.Primary)
      }
      .fontStyle(FontSet.Heading.heading1)
      Text("석촌호수로의 개화 상태를 기록해주세요")
        .fontStyle(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
    }
    
  }
  @ViewBuilder
  private var saveButton: some View {
    PIDButton(title: store.buttonTittle, size: .large)
      .action {
        store.send(.updateButtonTapped)
      }
      .isActive(store.isButtonEnable)
      .padding(.Number16)
  }

  // MARK: - Photo Section

  @ViewBuilder
  private var photoSection: some View {
    VStack(spacing: .Number12) {
      if let uiImage = store.selectedUIImage {
        // 사진 있음: 이미지 + X버튼 + 교체 버튼 + 라벨
        // 이미지 + X 버튼
        VStack(spacing: .Number8) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(width: .Number100, height: .Number100)
            .clipShape(RoundedRectangle(cornerRadius: .Number16))
            .overlay(alignment: .topTrailing) {
              PIDIconButton {
                Icon(image: .close)
                  .size(.medium)
                  .foregroundColor(ColorSet.Icon.Primary)
              }
              .buttonSize(.Number24)
              .backgroundColor(ColorSet.Gray._0)
              .action{
                store.send(.photoRemoveButtonTapped)
              }
              .padding(.top, .Number4)
              .padding(.trailing, .Number4)
            }
          
          // 사진 교체 버튼
          PIDUnderLineButton(
            title: "사진 교체",
            style: .primary
          ) {
            store.send(.photoButtonTapped)
          }
        }
        // 하단 라벨
        Text("공유해주신 사진은 상세 페이지에 첨부돼요")
          .fontStyle(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
      } else {
        // 사진 없음: "한 컷 공유하기" 버튼 + 하단 라벨
        VStack(spacing: .Number12) {
          PIDButton(title: "한 컷 공유하기", size: .medium) {
            Icon(image: .camera)
              .size(.medium)
              .foregroundColor(ColorSet.Icon.Accent)
          }
          .isSecondary(true)
          .textColor(ColorSet.Text.Accent)
          .isFullWidth(false)
          .action {
            store.send(.photoButtonTapped)
          }

          Text("공유해주신 사진은 상세 페이지에 첨부돼요")
            .fontStyle(FontSet.Body.body3)
            .foregroundStyle(ColorSet.Text.Secondary)
        }
      }
    }
  }
}

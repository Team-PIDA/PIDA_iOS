//
//  BloomingUpdateFeature.swift
//  BloomingFeatureInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit
import Shared
import ComposableArchitecture
import BloomingFeatureInterface
import BloomingClient
import APIClient
import DesignKit

extension BloomingUpdateFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.bloomingClient) var bloomingClient
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.mainQueue) var mainQueue

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .binding(\.selectedStatus):
        return .send(.changeStatus)

      case .changeStatus:
        if let _ = state.selectedStatus, !state.isButtonEnable {
          state.buttonTittle = "기록하기"
          state.isButtonEnable = true
        }
        return .none

      case .initialState:
        state.buttonTittle = "개화 상태를 선택해주세요"
        state.selectedStatus = nil
        state.isButtonEnable = false
        return .none

      case let .sendToastMessage(message):
        state.toastMessage = message
        return .none

      case let .setSpodtId(id):
        state.spotId = id
        return .none

      case let .setStreetName(streetName):
        state.streetName = streetName
        return .none

      case .updateButtonTapped:
        return .send(.updateBloomingRequest)
          .throttle(id: ID.throttle, for: 0.3, scheduler: mainQueue, latest: false)

      case .updateBloomingRequest:
        guard let id = state.spotId,
              let status = state.selectedStatus else {
          return .none
        }
        return updateBloomingRequest(
          id: id,
          status: status,
          imageData: state.selectedImageData
        )

      case let .dismiss(update, spotId):
        return .run { send in
          await send(.delegate(.dismiss(didUpdate: update, spotId: spotId)))
          await send(.initialState)
        }

      // MARK: - Photo Actions

      case .photoButtonTapped:
        state.isPhotoPickerPresented = true
        return .none

      case let .photoSelected(data):
        guard let data,
              let originalImage = UIImage(data: data),
              let resizedImage = originalImage.resized(maxSize: 1024),
              let resizedData = resizedImage.jpegData(compressionQuality: 0.8) else {
          state.selectedImageData = nil
          state.isPhotoPickerPresented = false
          return .none
        }
        state.selectedImageData = resizedData
        state.isPhotoPickerPresented = false
        return .none

      case let .uploadImage(url, data):
        return .run { [apiClient] _ in
          do {
            try await apiClient.upload(url: url, data: data)
          } catch {
            // 실패해도 무시 - 개화 상태는 이미 기록됨
            print("[BloomingFeature] Image upload failed: \(error)")
          }
        }

      case .binding, .delegate:
        return .none
      }
    }
  }
}

extension BloomingUpdateFeature.Core {
  private func updateBloomingRequest(
    id: Int,
    status: BloomStatus,
    imageData: Data?
  ) -> Effect<Action> {
    return .run { send in
      do {
        let result = try await bloomingClient.updateBloomingState(
          id: id,
          status: status.rawValue
        )

        // 즉시 화면 dismiss + Toast 표시
        await send(.dismiss(didUpdate: true, spotId: id))
        await send(.sendToastMessage(result.message))

        // 이미지가 있고 uploadUrl이 있으면 백그라운드 업로드
        if let imageData,
           let uploadUrl = result.uploadUrl {
          await send(.uploadImage(url: uploadUrl, data: imageData))
        }
      } catch {
        await send(.sendToastMessage("기록에 실패했어요"))
      }
    }
  }
}

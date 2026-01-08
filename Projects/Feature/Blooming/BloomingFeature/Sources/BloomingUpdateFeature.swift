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

      case .photoRemoveButtonTapped:
        state.selectedImageData = nil
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

      case .uploadImage:
        // Task.detached로 직접 처리하므로 여기서는 아무것도 하지 않음
        return .none

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
    return .run { [apiClient] send in
      do {
        let result = try await bloomingClient.updateBloomingState(
          id: id,
          status: status.rawValue
        )

        // 이미지 업로드를 독립적인 Task로 실행 (dismiss 후에도 계속 실행)
        if let imageData,
           let uploadUrl = result.uploadUrl {
          Task.detached {
            do {
              try await apiClient.upload(url: uploadUrl, data: imageData)
            } catch {
              print("[BloomingFeature] Image upload failed: \(error)")
            }
          }
        }

        // 화면 dismiss + Toast 표시
        await send(.dismiss(didUpdate: true, spotId: id))
        await send(.sendToastMessage(result.message))
      } catch {
        await send(.sendToastMessage("기록에 실패했어요"))
      }
    }
  }
}

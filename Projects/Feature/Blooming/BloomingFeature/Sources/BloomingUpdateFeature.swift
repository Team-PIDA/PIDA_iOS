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
import AnalyticsClient

extension BloomingUpdateFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.bloomingClient) var bloomingClient
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.analyticsClient) var analyticsClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .onAppear:
        state.updateStartTime = Date()
        // update_start 이벤트 트래킹
        if let spotId = state.spotId {
          analyticsClient.track(
            BloomingEvent.updateStart(
              spotId: spotId,
              distanceFromSpot: state.distanceFromSpot
            )
          )
        }
        return .none

      case .binding(\.selectedStatus):
        // bloom_status_option 이벤트 트래킹
        if let status = state.selectedStatus {
          let statusOption: BloomingEvent.StatusOption
          switch status {
          case .little:
            statusOption = .notYet
          case .bloomed:
            statusOption = .fullBloom
          case .withered:
            statusOption = .fallen
          case .notBloomed:
            statusOption = .notYet
          }
          analyticsClient.track(
            BloomingEvent.statusOption(
              distanceFromSpot: state.distanceFromSpot,
              statusOption: statusOption
            )
          )
        }
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
        state.isCompleted = false
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
        state.isButtonLoading = true
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
          imageData: state.selectedImageData,
          distanceFromSpot: state.distanceFromSpot,
          updateStartTime: state.updateStartTime
        )

      case let .dismiss(update, spotId):
        return .run { send in
          await send(.delegate(.dismiss(didUpdate: update, spotId: spotId)))
          await send(.initialState)
        }

      // MARK: - Photo Actions

      case .photoButtonTapped:
        state.isPhotoPickerPresented = true
        // upload_photo 이벤트 트래킹
        analyticsClient.track(
          BloomingEvent.uploadPhoto(
            distanceFromSpot: state.distanceFromSpot,
            isStatusRecorded: state.selectedStatus != nil
          )
        )
        return .none

      case .photoRemoveButtonTapped:
        state.selectedImageData = nil
        state.selectedUIImage = nil
        return .none

      case let .photoSelected(data):
        guard let data,
              let originalImage = UIImage(data: data),
              let result = originalImage.resizedJPEGData(maxSize: 1024) else {
          state.selectedImageData = nil
          state.selectedUIImage = nil
          state.isPhotoPickerPresented = false
          return .none
        }
        state.selectedImageData = result.data
        state.selectedUIImage = result.image
        state.isPhotoPickerPresented = false
        return .none

      case .uploadImage:
        // Task.detached로 직접 처리하므로 여기서는 아무것도 하지 않음
        return .none

      case let .setCompleted(isCompleted):
        state.isCompleted = isCompleted
        state.isButtonLoading = false
        return .none

      case let .setButtonLoading(isLoading):
        state.isButtonLoading = isLoading
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
    imageData: Data?,
    distanceFromSpot: Double?,
    updateStartTime: Date?
  ) -> Effect<Action> {
    return .run { [apiClient, analyticsClient] send in
      do {
        let result = try await bloomingClient.updateBloomingState(
          id: id,
          status: status.rawValue
        )

        // bloom_status_submitted 이벤트 트래킹
        let completeDuration: Double
        if let startTime = updateStartTime {
          completeDuration = Date().timeIntervalSince(startTime)
        } else {
          completeDuration = 0
        }
        analyticsClient.track(
          BloomingEvent.statusSubmitted(
            distanceFromSpot: distanceFromSpot,
            completeDurationSeconds: completeDuration
          )
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

        // 완료 화면으로 전환
        await send(.setCompleted(true))
      } catch {
        await send(.setButtonLoading(false))
        await send(.sendToastMessage("기록에 실패했어요"))
      }
    }
  }
}

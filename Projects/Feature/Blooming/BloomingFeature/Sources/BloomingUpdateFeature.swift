//
//  BloomingUpdateFeature.swift
//  BloomingFeatureInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Shared
import ComposableArchitecture
import BloomingFeatureInterface
import BloomingClient

extension BloomingUpdateFeature {
  public init() {
    self.init(reducer: Reduce(BloomingUpdateFeature()))
  }

  struct BloomingUpdateFeature: Reducer {
    @Dependency(\.bloomingClient) var bloomingClient
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
        guard let id = state.spotId, let status = state.selectedStatus else { return .none }
        return .run { send in
          do {
            let result = try await bloomingClient.updateBloomingState(id: id, status: status.rawValue)
            await send(.dismiss(didUpdate: true, spotId: id))
            await send(.sendToastMessage(result.message))
          } catch {
            await send(.sendToastMessage("기록에 실패했어요"))
          }
        }

      case let .dismiss(update, spotId):
        return .run { send in
          await send(.delegate(.dismiss(didUpdate: update, spotId: spotId)))
          await send(.initialState)
        }

      case .binding, .delegate:
        return .none
      }
    }
  }
}

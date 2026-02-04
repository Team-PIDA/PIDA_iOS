//
//  BloomingUpdateFeature.swift
//  BloomingFeatureInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit
import DesignKit
import ComposableArchitecture


@Reducer
public struct BloomingUpdateFeature {
  private let reducer: Reduce<State, Action>
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var streetName: String = ""
    public var spotId: Int? = nil
    public var isButtonEnable: Bool = false
    public var buttonTittle: String = "기록하기"
    public var selectedStatus: BloomStatus? = nil
    public var toastMessage: String? = nil

    // 이미지 관련 상태
    public var selectedImageData: Data? = nil
    public var selectedUIImage: UIImage? = nil
    public var isPhotoPickerPresented: Bool = false

    // Analytics 상태
    public var distanceFromSpot: Double? = nil
    public var updateStartTime: Date? = nil

    // 완료 페이지 상태
    public var isCompleted: Bool = false

    // 버튼 로딩 상태
    public var isButtonLoading: Bool = false

    // Alert 상태
    public var alertType: AlertType? = nil

    public init(spotId: Int?, streetName: String, distanceFromSpot: Double? = nil) {
      self.spotId = spotId
      self.streetName = streetName
      self.distanceFromSpot = distanceFromSpot
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)

    case onAppear
    case changeStatus
    case initialState
    case sendToastMessage(String)

    case updateButtonTapped
    case updateBloomingRequest

    case setSpodtId(Int)
    case setStreetName(String)

    // 이미지 관련 액션
    case photoButtonTapped
    case photoRemoveButtonTapped
    case photoSelected(Data?)
    case uploadImage(url: String, data: Data)

    // 완료 상태 액션
    case setCompleted(Bool)

    // 버튼 로딩 상태 액션
    case setButtonLoading(Bool)

    // Alert 관련 액션
    case presentAlert(AlertType)
    case alertAcceptTapped
    case clearAlertState

    case delegate(Delegate)
    case dismiss(didUpdate: Bool, spotId: Int) // 상태 기록 완료 여부
  }
  
  public enum Delegate: Equatable {
    case dismiss(didUpdate: Bool, spotId: Int)
  }
  
  public enum ID: Hashable {
    case throttle
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

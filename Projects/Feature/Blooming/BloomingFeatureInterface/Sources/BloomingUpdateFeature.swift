//
//  BloomingUpdateFeature.swift
//  BloomingFeatureInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
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
    public var buttonTittle: String = "개화 상태를 선택해주세요"
    public var selectedStatus: BloomStatus? = nil
    public var toastMessage: String? = nil

    // 이미지 관련 상태
    public var selectedImageData: Data? = nil
    public var isPhotoPickerPresented: Bool = false

    public init(spotId: Int?, streetName: String) {
      self.spotId = spotId
      self.streetName = streetName
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)

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

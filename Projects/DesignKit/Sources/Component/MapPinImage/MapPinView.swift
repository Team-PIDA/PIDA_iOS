//
//  MapPinImage.swift
//  DesignKit
//
//  Created by Jiyeon on 3/13/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI

public struct MapPinView: View {
  var state: MapPinState
  var status: BloomStatus
  var type: MapSpotType
  
  public init(state: MapPinState, status: BloomStatus, type: MapSpotType) {
    self.state = state
    self.status = status
    self.type = type
  }
  
  public var body: some View {
    if state == .active {
      activePin
    } else {
      inactivePin
    }
  }
  
  private var activePin: some View {
    ZStack(alignment: .top) {
      Image(asset: status.activePinImage)
      VStack(spacing: .Number0) {
        Image(asset: type.icon.swiftUIImage)
          .renderingMode(.template)
          .resizable()
          .frame(width: 36, height: 36)
          .foregroundColor(ColorSet.Icon.Inverse)
          Spacer()
      }
      .padding(.top, .Number16)
    }
  }
  
  private var inactivePin: some View {
    ZStack(alignment: .center) {
      Image(asset: status.inactivePinImage)
      Image(asset: type.icon.swiftUIImage)
        .renderingMode(.template)
        .resizable()
        .frame(width: 14, height: 14)
        .foregroundColor(ColorSet.Icon.Inverse)
    }
  }
}


fileprivate extension BloomStatus {
  var activePinImage: DesignKitImages {
    switch self {
    case .little:
      ImageSet.littleActivePin.swiftUIImage
    case .bloomed:
      ImageSet.bloomActivePin.swiftUIImage
    case .withered:
      ImageSet.witheredPinActive.swiftUIImage
    case .notBloomed:
      ImageSet.notBloomActivePin.swiftUIImage
    }
  }
  
  var inactivePinImage: DesignKitImages {
    switch self {
    case .little:
      ImageSet.littlePin.swiftUIImage
    case .bloomed:
      ImageSet.bloomPin.swiftUIImage
    case .withered:
      ImageSet.witheredPin.swiftUIImage
    case .notBloomed:
      ImageSet.notBloomPin.swiftUIImage
    }
  }
}


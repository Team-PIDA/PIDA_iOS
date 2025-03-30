//
//  StateRadioButton.swift
//  BloomingDemo
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import Utility
import DesignKit

struct StateRadioButton: View {
  @Binding private var selectedStatus: BloomStatus?
  
  init(status: Binding<BloomStatus?>) {
    self._selectedStatus = status
  }
  
  var body: some View {
    HStack(spacing: .Number12) {
      statusButton(state: .little)
      statusButton(state: .bloomed)
      statusButton(state: .withered)
    }
  }
  
  private func statusButton(state: BloomStatus) -> some View {
    SquareButton(
      title: state.text,
      isSelected: Binding(
        get: { selectedStatus == state },
        set: { newValue in
          if newValue {
            selectedStatus = state
          }
        }
      ),
      iconView: {
        state.image?
          .resizable()
          .frame(width: .Number40, height: .Number40)
      }
    )
    .frame(width: .Number100, height: .Number100)
    .onTapGesture {
      selectedStatus = state
    }
  }
}

extension BloomStatus {
  fileprivate var image: Image? {
    switch self {
    case .little:
      Image(asset: ImageSet.fewLargePin.swiftUIImage)
    case .bloomed:
      Image(asset: ImageSet.manyLargePin.swiftUIImage)
    case .withered:
      Image(asset: ImageSet.goneLargePin.swiftUIImage)
    default:
      nil
    }
  }
}


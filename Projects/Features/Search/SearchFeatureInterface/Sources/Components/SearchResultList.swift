//
//  SearchResultList.swift
//  SearchFeatureInterface
//
//  Created by Jiyeon on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit
import FlowerSpotDomainInterface

/// 검색 결과 리스트 셀
///
/// `onTap`: 리스트 탭 시 리스트 값을 리턴하는 클로저
public struct SearchResultList: View {
  
  private var item: FlowerSpot
  private var onTap: ((FlowerSpot) async -> Void)?
  
  public init(
    item: FlowerSpot,
    onTap: ((FlowerSpot) async -> Void)? = nil
  ) {
    self.item = item
    
    self.onTap = onTap
    
  }
  public var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: .Number0) {
          Text(item.streetName)
            .fontStyle(FontSet.Body.body2)
            .foregroundStyle(ColorSet.Text.Primary)
          Text(item.address ?? "")
            .fontStyle(FontSet.Caption.caption1)
            .foregroundStyle(ColorSet.Text.Tertiary)
        }
        Spacer()
        Text("10km")
          .fontStyle(FontSet.Caption.caption1)
          .foregroundStyle(ColorSet.Text.Tertiary)
      }
      .padding(.vertical, .Number12)
      BorderView(size: .long)
    }
    .contentShape(Rectangle())
    .padding(.horizontal, .Number16)
    .onTapGesture {
      if let onTap = onTap {
        Task { @MainActor in
          await onTap(item)
        }
      }
    }
    
  }
  
}

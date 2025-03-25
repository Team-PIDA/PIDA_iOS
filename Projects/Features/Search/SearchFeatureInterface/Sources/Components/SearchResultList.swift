//
//  SearchResultList.swift
//  SearchFeatureInterface
//
//  Created by Jiyeon on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit

/// 검색 결과 리스트 셀
///
/// `onTap`: 리스트 탭 시 리스트 값을 리턴하는 클로저
public struct SearchResultList: View {
  private var id: Int
  private let roadName: String
  private let address: String
  private let subInfo: String
  private var onTap: ((Int) async -> Void)?
  
  public init(
    id: Int,
    roadName: String,
    address: String,
    subInfo: String,
    onTap: ((Int) async -> Void)? = nil
  ) {
    self.id = id
    self.roadName = roadName
    self.address = address
    self.subInfo = subInfo
    self.onTap = onTap
    
  }
  public var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: .Number0) {
          Text(roadName)
            .fontStyle(FontStyle.Body.body2)
            .foregroundStyle(ColorSet.Text.Primary)
          Text(address)
            .fontStyle(FontStyle.Caption.caption1)
            .foregroundStyle(ColorSet.Text.Tertiary)
        }
        Spacer()
        Text(subInfo)
          .fontStyle(FontStyle.Caption.caption1)
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
          await onTap(id)
        }
      }
    }
    
  }
  
}

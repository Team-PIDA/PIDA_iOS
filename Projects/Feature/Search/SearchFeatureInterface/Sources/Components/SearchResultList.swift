//
//  SearchResultList.swift
//  SearchFeatureInterface
//
//  Created by Jiyeon on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit
import SearchClient

public struct SearchResultList: View {
  
  private var item: PlaceSearchEntity
  private var onTap: ((PlaceSearchEntity) async -> Void)?
  
  public init(
    item: PlaceSearchEntity,
    onTap: ((PlaceSearchEntity) async -> Void)? = nil
  ) {
    self.item = item
    
    self.onTap = onTap
    
  }
  public var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: .Number0) {
          Text(item.name)
            .fontStyle(FontSet.Body.body2)
            .foregroundStyle(ColorSet.Text.Primary)
          if let address = item.address {
            Text(address)
              .fontStyle(FontSet.Caption.caption1)
              .foregroundStyle(ColorSet.Text.Tertiary)
          }
        }
        Spacer()
        if let subInfo = item.subInfo {
          Text(subInfo)
            .fontStyle(FontSet.Caption.caption1)
            .foregroundStyle(ColorSet.Text.Tertiary)
        }
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

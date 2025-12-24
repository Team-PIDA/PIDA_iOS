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
  
  private var item: SearchListCellEntity
  private var onTap: ((SearchListCellEntity) async -> Void)?
  
  public init(
    item: SearchListCellEntity,
    onTap: ((SearchListCellEntity) async -> Void)? = nil
  ) {
    self.item = item
    
    self.onTap = onTap
    
  }
  public var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: .Number0) {
          Text(item.streetName ?? "")
            .fontStyle(FontSet.Body.body2)
            .foregroundStyle(ColorSet.Text.Primary)
          Text(item.address ?? "")
            .fontStyle(FontSet.Caption.caption1)
            .foregroundStyle(ColorSet.Text.Tertiary)
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

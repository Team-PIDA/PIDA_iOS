//
//  SearchResultList.swift
//  SearchFeatureInterface
//
//  Created by Jiyeon on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit

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
        VStack(alignment: .leading) {
          Text(roadName)
            .font(FontSet.Body.body2)
            .foregroundStyle(ColorSet.Text.Primary)
          Text(address)
            .font(FontSet.Caption.caption1)
            .foregroundStyle(ColorSet.Text.Tertiary)
        }
        Spacer()
        Text(subInfo)
          .font(FontSet.Caption.caption1)
          .foregroundStyle(ColorSet.Text.Tertiary)
      }
      .frame(height: .Number66)
      
      BorderView(size: .long)
    }
    .contentShape(Rectangle())
    .padding(.horizontal, 16)
    .onTapGesture {
      if let onTap = onTap {
        Task { @MainActor in
          await onTap(id)
        }
      }
    }
    
  }
  
}

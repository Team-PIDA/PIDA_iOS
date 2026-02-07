//
//  CategoryButton.swift
//  DesignKit
//
//  Created by Jiyeon on 2/7/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI

public struct CategoryButton: View {
  
  private var title: String
  private var icon: ImageSet?
  var isActive: Bool
  
  public init(
    title: String,
    icon: ImageSet? = nil,
    isActive: Bool
  ) {
    self.title = title
    self.icon = icon
    self.isActive = isActive
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: .Number4) {
      if let icon = icon {
        Icon(image: icon, size: .small, color: iconColor)
      }
      Text(title)
        .fontStyle(FontSet.Body.body3)
        .foregroundStyle(textColor)
    }
    .padding(.leading, icon == .none ? .Number16 : .Number12)
    .padding(.trailing, .Number16)
    .padding(.vertical, .Number6)
    .background(bgColor)
    .cornerRadius(.Number100)
    .overlay(
      RoundedRectangle(cornerRadius: .Number100)
        .inset(by: 0.5)
        .stroke(borderColor, lineWidth: .Number1)
    )
  }
}

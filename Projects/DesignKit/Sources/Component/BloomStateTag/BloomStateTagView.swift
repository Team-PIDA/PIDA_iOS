//
//  BloomStateTagView.swift
//  DesignKit
//
//  Created by Jiyeon on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI

public struct BloomStateTagView: View {
  private var state: BloomStatus
  
  public init(state: BloomStatus) {
    self.state = state
  }
  
  public var body: some View {
    HStack(spacing: .Number2) {
      GradiantIcon(image: .flower)
        .size(.small)
        .foregroundStyle(state.gradiant)
      Text(state.text)
        .fontStyle(FontSet.Caption.caption1)
        .foregroundColor(state.textColor)
    }
    .padding(.horizontal, .Number6)
    .padding(.vertical, .Number2)
    .background(state.backgroundColor)
    .cornerRadius(.Number4)
  }
}

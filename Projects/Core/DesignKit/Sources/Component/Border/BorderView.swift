//
//  BorderView.swift
//  DesignKit
//
//  Created by Jiyeon on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI



public struct BorderView: View {
  private let size: BorderSize
  var color: Color = ColorSet.Border.Secondary
  
  public init(size: BorderSize) {
    self.size = size
  }
  public var body: some View {
    
    Rectangle()
      .fill(color)
      .frame(height: size.height)
  }
}

#Preview {
  VStack(spacing: 8) {
    BorderView(size: .short)
    BorderView(size: .long)
    BorderView(size: .xlarge)
  }
}

//
//  ContentView.swift
//  PIDA
//
//  Created by Jiyeon on 3/13/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit

struct ContentView: View {
  
  typealias Font = DesignKitFontFamily.FontSet
  typealias Color = DesignKitAsset.ColorSet
  
  var body: some View {
    Text("Hello, World!")
      .font(Font.Heading.heading1)
    Rectangle()
      .fill(Color.GradiantSet.gra1)
  }
  
}

#Preview {
  ContentView()
}

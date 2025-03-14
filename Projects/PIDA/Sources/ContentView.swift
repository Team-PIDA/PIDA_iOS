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
  typealias Icon = DesignKitAsset.Icons
  
  var body: some View {
    Text("Hello, World!")
      .font(Font.Heading.heading1)
      //이미지를 추가
      .overlay {
        Image(asset: Icon.chevronRight)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(Color.Button.Error)
      }
    Rectangle()
      .fill(Color.GradiantSet.gra1)
  }
}

#Preview {
  ContentView()
}

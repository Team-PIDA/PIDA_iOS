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
  
  var body: some View {
    Text("Hello, World!")
      .font(FontSet.Heading.heading1)
      //이미지를 추가
      .overlay {
        Image(asset: IconSet.chevronRight)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(ColorSet.Button.Error)
      }
    Rectangle()
      .fill(ColorSet.GradiantSet.gra1)
  }
}

#Preview {
  ContentView()
}

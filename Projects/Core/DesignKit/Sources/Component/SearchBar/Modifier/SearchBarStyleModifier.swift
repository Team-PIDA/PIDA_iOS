//
//  SearchBarStyleModifier.swift
//  DesignKit
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

struct SearchBarStyleModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(height: .Number48)
      .background(ColorSet.Background.Primary)
      .cornerRadius(.Number10)
  }
}

extension View {
  func searchBarStyle() -> some View {
    self.modifier(SearchBarStyleModifier())
  }
}

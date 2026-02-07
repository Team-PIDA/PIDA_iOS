//
//  CategoryButton+.swift
//  DesignKit
//
//  Created by Jiyeon on 2/7/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI

extension CategoryButton {
  
  var bgColor: Color {
    isActive ? ColorSet.Background.Accent : ColorSet.Background.Primary
  }
  
  var borderColor: Color {
    isActive ? ColorSet.Border.Accent : ColorSet.Border.Primary
  }
  
  var textColor: Color {
    isActive ? ColorSet.Text.Accent : ColorSet.Text.Primary
  }
  
  var iconColor: Color {
    isActive ? ColorSet.Icon.Accent : ColorSet.Icon.Primary
  }
}

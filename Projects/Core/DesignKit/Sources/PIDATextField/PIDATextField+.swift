//
//  PIDATextField+.swift
//  DesignKit
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public extension PIDATextField {
  func onSubmit(_ action: @escaping () -> Void) -> Self {
    var textfield = self
    textfield.onSubmit = action
    return textfield
  }
}

//
//  UIApplication+.swift
//  Utility
//
//  Created by Jiyeon on 3/22/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit

public extension UIApplication {
  var currentWindow: UIWindow? {
    // 활성화된 scene 중 UIWindowScene으로 캐스팅하고, keyWindow를 반환
    return self.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }
  
  var safeAreaTopInset: CGFloat {
    let window = connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    return window?.safeAreaInsets.top ?? 44
  }
  
  var safeAreaBottomInset: CGFloat {
    let window = connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    return window?.safeAreaInsets.bottom ?? 34
  }
}

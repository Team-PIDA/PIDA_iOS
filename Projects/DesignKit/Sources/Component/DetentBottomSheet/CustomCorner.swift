//
//  CustomCorner.swift
//  DesignKit
//
//  Created by Jiyeon on 1/8/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI

public struct CustomCorner: Shape {
  var corners: UIRectCorner
  var radius: CGFloat
  
  public func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: .init(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

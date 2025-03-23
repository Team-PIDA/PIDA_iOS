//
//  Icon.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct Icon: View {
  
  public var image: ImageSet
  public var size: IconSize = .large
  public var color: Color = ColorSet.Icon.Primary
  
  public init(
    image: ImageSet
  ) {
    self.image = image
  }
  
  public var body: some View {
    Image(asset: image.swiftUIImage)
      .renderingMode(.template)
      .resizable()
      .scaledToFit()
      .frame(width: size.dimension, height: size.dimension)
      .foregroundColor(color)
  }
}

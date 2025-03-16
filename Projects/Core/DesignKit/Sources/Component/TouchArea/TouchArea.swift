//
//  TouchArea.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct TouchArea: View {
  
  public var image: Image
  public var action: (() async -> Void)? = nil
  public var size: IconSize = .superLage
  public var color: Color = ColorSet.Icon.Primary
  
  public init(
    image: Image
  ) {
    self.image = image
  }
  
  public var body: some View {
    content
  }
  
  @ViewBuilder private var content: some View {
    Rectangle()
      .fill(.clear)
      .overlay {
        Icon(icon: image)
          .size(size)
      }
      .padding(12)
      .onTapGesture {
        if let action = action {
          Task { @MainActor in
            await action()
          }
        }
      }
      .frame(width: 48, height: 48)
  }
}

#Preview {
  HStack {
    TouchArea(image: IconSet.close.swiftUIImage)
      .size(.superLage)
      .action { print("Super Large") }
    
    TouchArea(image: IconSet.close.swiftUIImage)
      .size(.large)
      .action { print("Large") }
    
    TouchArea(image: IconSet.close.swiftUIImage)
      .size(.medium)
      .action { print("Medium") }
    
    TouchArea(image: IconSet.close.swiftUIImage)
      .size(.small)
      .action { print("small") }
  }
}

//
//  TouchArea.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct TouchArea: View {
  
  public var image: ImageSet
  public var action: (() async -> Void)? = nil
  public var size: IconSize = .superLage
  public var color: Color = ColorSet.Icon.Primary
  
  public init(
    image: ImageSet
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
        Icon(image: image)
          .size(size)
      }
      .padding(.Number12)
      .onTapGesture {
        if let action = action {
          Task { @MainActor in
            await action()
          }
        }
      }
      .frame(width: .Number48, height: .Number48)
  }
}

#Preview {
  HStack {
    TouchArea(image: .close)
      .size(.superLage)
      .action { print("Super Large") }
      .border(Color.red)
    
    TouchArea(image: .close)
      .size(.large)
      .action { print("Large") }
      .border(Color.red)
    
    TouchArea(image: .close)
      .size(.medium)
      .action { print("Medium") }
      .border(Color.red)
    
    TouchArea(image: .close)
      .size(.small)
      .action { print("small") }
      .border(Color.red)
  }
}

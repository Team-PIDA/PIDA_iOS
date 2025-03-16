//
//  TopBar.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct NavigationBar<BackContent: View, CloseContent: View>: View {
  
  public let backContent: (() -> BackContent)?
  public let closeContent: (() -> CloseContent)?
  public let title: String?
  
  public init(
    @ViewBuilder backContent: @escaping () -> BackContent = { Spacer().frame(width: 44, height: 44) },
    title: String? = nil,
    @ViewBuilder closeContent: @escaping () -> CloseContent = { Spacer().frame(width: 44, height: 44) }
  ) {
    self.backContent = backContent
    self.title = title
    self.closeContent = closeContent
  }
  
  public var body: some View {
    content
  }
  
  @ViewBuilder
  private var content: some View {
    HStack {
      backContent.map {
        $0().padding(.leading, 4)
      }
      Spacer()
      if let title = title { Text(title) }
      Spacer()
      closeContent.map {
        $0().padding(.leading, 4)
      }
    }
  }
}

#Preview {
  List {
    Section("뒤로가기 + 타이틀 + 닫기") {
      NavigationBar(
        backContent: {
          TouchArea(image: IconSet.back.swiftUIImage)
            .size(.superLage)
        },
        title: "text",
        closeContent: {
          TouchArea(image: IconSet.close.swiftUIImage)
            .size(.superLage)
        }
      )
      .border(Color.red)
    }
    
    Section("뒤로가기 + 타이틀") {
      NavigationBar(
        backContent: {
          TouchArea(image: IconSet.back.swiftUIImage)
            .size(.superLage)
            .action {
              print("뒤로가기 버튼")
            }
        },
        title: "text"
      )
      .border(Color.red)
    }
    
    Section("타이틀 + 닫기") {
      NavigationBar(
        title: "text",
        closeContent: {
          TouchArea(image: IconSet.close.swiftUIImage)
            .size(.superLage)
            .action {
              print("닫기 버튼")
            }
        }
      )
      .border(Color.red)
    }
  }
}

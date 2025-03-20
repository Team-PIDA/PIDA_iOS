//
//  SearchBar.swift
//  DesignKit
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct SearchBar<LeadingContent: View, TrailingContent: View>: View {
  
  @Binding private var text: String
  private let placeholder: String
  private var mode: SearchBarMode
  private let leadingContent: (() -> LeadingContent)?
  private let trailingContent: (() -> TrailingContent)?
  public var onTap: (() -> Void)?
  public var onSubmit: (() -> Void)?
  
  
  public init(
    text: Binding<String> = .constant(""),
    placeholder: String? = nil,
    mode: SearchBarMode = .main,
    @ViewBuilder leadingContent: @escaping () -> LeadingContent = {  Spacer().frame(width: .Number48, height: .Number48)
    },
    @ViewBuilder trailingContent: @escaping () -> TrailingContent = { Spacer().frame(width: .Number48, height: .Number48)
    }
  ) {
    self._text = text
    self.placeholder = placeholder ?? ""
    self.mode = mode
    self.leadingContent = leadingContent
    self.trailingContent = trailingContent
  }
  
  public var body: some View {
    switch mode {
    case .main:
      mainModeView
    case .searchable:
      searchableModeView
    case .result:
      resultModeView
    }
  }
  
  @ViewBuilder
  private var mainModeView: some View {
    HStack {
      searchIconView
      
      Text(placeholder)
        .foregroundColor(ColorSet.Text.Tertiary)
        .font(FontSet.Body.body2)
      
      Spacer()
      
      trailingContent?()
    }
    .searchBarStyle()
    .elevation(cornerRadius: .Number10)
    .onTapGesture {
      onTap?()
    }
  }
  
  @ViewBuilder
  private var searchableModeView: some View {
    HStack {
      searchIconView
      
      TextField(placeholder, text: $text)
        .submitLabel(.search)
        .onSubmit {
          onSubmit?()
        }
      
      trailingContent?()
    }
    .searchBarStyle()
    .overlay(
      RoundedRectangle(cornerRadius: .Number10)
        .stroke(
          ColorSet.Border.Primary,
          lineWidth: .Number1
        )
    )
    
  }
  
  @ViewBuilder
  private var resultModeView: some View {
    HStack {
      leadingContent?()
      
      Text(text)
        .foregroundColor(ColorSet.Text.Primary)
        .font(FontSet.Body.body2)
      
      Spacer()
      
      trailingContent?()
    }
    .searchBarStyle()
    .elevation(cornerRadius: .Number10)
  }
  
  @ViewBuilder
  private var searchIconView: some View {
    Icon(image: .search)
      .size(.extraLarge)
      .foregroundColor(ColorSet.Icon.Secondary)
      .frame(width: .Number48, height: .Number48)
  }
}



#Preview {
  VStack(spacing: 20) {
    // 메인 화면의 검색바
    SearchBar(
      placeholder: "방문할 장소를 입력하세요",
      mode: .main,
      trailingContent: {
        PIDIconButton {
          Image(asset: ImageSet.avatar.swiftUIImage)
            .resizable()
            .scaledToFit()
            .frame(width: .Number32, height: .Number32)
        }
      }
    )
    .onTap {
      print("TOUCH")
    }
    .padding(.horizontal, 16)
    
    // 검색 화면의 검색바
    SearchBar(
      text: .constant(""),
      placeholder: "방문할 장소를 입력하세요",
      mode: .searchable
    )
    .padding(.horizontal, 16)
    
    // 검색 결과 선택 후의 검색바
    SearchBar(
      text: .constant("카페"),
      mode: .result,
      leadingContent: {
        TouchArea(image: .back)
          .size(.extraLarge)
          .action {
            print("뒤로가기")
          }
      }
    )
    .padding(.horizontal, 16)
  }
  
}


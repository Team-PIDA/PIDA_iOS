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
  
  /// TextField 비활성화 시 SearchBar 이벤트 받기 위한 클로저
  public var onTap: (() -> Void)?
  /// TextField 활성화 시 검색 완료 이벤트 받기 위한 클로저
  public var onSubmit: (() async -> Void)?
  /// 키보드 활성화 여부
  @Binding var isFocused: Bool
  
  public init(
    text: Binding<String> = .constant(""),
    placeholder: String? = nil,
    mode: SearchBarMode = .main,
    isFocused: Binding<Bool> = .constant(false),
    @ViewBuilder leadingContent: @escaping () -> LeadingContent = {  Spacer().frame(width: .Number48, height: .Number48)
    },
    @ViewBuilder trailingContent: @escaping () -> TrailingContent = { Spacer().frame(width: .Number48, height: .Number48)
    }
  ) {
    self._text = text
    self.placeholder = placeholder ?? ""
    self.mode = mode
    self._isFocused = isFocused
    self.leadingContent = leadingContent
    self.trailingContent = trailingContent
  }
  
  public var body: some View {
    switch mode {
    case .main:
      mainModeView
    case .search:
      searchModeView
    case .result:
      resultModeView
    }
  }
  
  // MARK: - Mode
  
  @ViewBuilder
  private var mainModeView: some View {
    HStack(spacing: 0) {
      searchIconView
      Text(placeholder)
        .foregroundColor(ColorSet.Text.Tertiary)
        .fontStyle(FontSet.Body.body2)
      Spacer()
      trailingContent?()
    }
    .searchBarStyle()
    .elevation(cornerRadius: .Number10)
    .contentShape(Rectangle())
    .onTapGesture {
      if let onTap = onTap {
        onTap()
      }
    }
  }
  
  @ViewBuilder
  private var searchModeView: some View {
    HStack(spacing: 0) {
      leadingContent?()
      PIDATextField(
        text: $text,
        placeholder: placeholder,
        isFocused: $isFocused
      )
      .submitLabel(.go)
      .onSubmit {
        if let onSubmit = onSubmit {
          Task { @MainActor in
            await onSubmit()
          }
        }
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
    HStack(spacing: 0) {
      leadingContent?()
      Text(text)
        .foregroundColor(ColorSet.Text.Primary)
        .fontStyle(FontSet.Body.body2)
      Spacer()
      trailingContent?()
    }
    .contentShape(Rectangle())
    .onTapGesture {
      if let onTap = onTap {
        onTap()
      }
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
  VStack(spacing: .Number20) {
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
    .padding(.horizontal, .Number16)
    
    // 검색 화면의 검색바
    SearchBar(
      text: .constant(""),
      placeholder: "방문할 장소를 입력하세요",
      mode: .search,
      leadingContent: {
        TouchArea(image: .back)
          .size(.extraLarge)
          .action {
            print("뒤로가기")
          }
      }
    )
    .padding(.horizontal, .Number16)
    
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
    .padding(.horizontal, .Number16)
  }
  
}


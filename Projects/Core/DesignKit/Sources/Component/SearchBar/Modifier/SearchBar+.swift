//
//  SearchBar+.swift
//  DesignKit
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public extension SearchBar {
  /// SearchBar를 탭했을 때의 동작을 설정
  func onTap(_ action: @escaping () -> Void) -> Self {
    var searchBar = self
    searchBar.onTap = action
    return searchBar
  }
  
  /// SearchBar에서 검색 완료 시 이벤트
  func onSubmit(_ action: @escaping () -> Void) -> Self {
    var searchBar = self
    searchBar.onSubmit = action
    return searchBar
  }
  
  func isFocused(_ isFocused: Bool) -> Self {
    var searchBar = self
    searchBar.isFocused = isFocused
    return searchBar
  }
}

//
//  ScrollViewConfigurator.swift
//  DesignKit
//
//  Created by 조용인
//

import SwiftUI

/// UIScrollView의 속성을 제어하기 위한 UIViewRepresentable.
/// ScrollView 콘텐츠의 `.background()`에 배치하여 부모 UIScrollView를 찾아 설정합니다.
///
/// ```swift
/// ScrollView {
///   content
///     .background(ScrollViewConfigurator(bounces: false))
/// }
/// ```
public struct ScrollViewConfigurator: UIViewRepresentable {
  public var bounces: Bool

  public init(bounces: Bool) {
    self.bounces = bounces
  }

  public func makeUIView(context: Context) -> UIView {
    let view = UIView(frame: .zero)
    view.isHidden = true
    view.isUserInteractionEnabled = false
    return view
  }

  public func updateUIView(_ uiView: UIView, context: Context) {
    DispatchQueue.main.async {
      var current: UIView? = uiView
      while let view = current {
        if let scrollView = view as? UIScrollView {
          scrollView.bounces = bounces
          break
        }
        current = view.superview
      }
    }
  }
}

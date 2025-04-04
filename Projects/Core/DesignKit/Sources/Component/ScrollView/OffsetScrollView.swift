//
//  OffsetScrollView.swift
//  DesignKit
//
//  Created by 조용인 on 4/2/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct OffsetObservableScrollView<Content: View>: View {
  public var axes: Axis.Set = .vertical
  public var showsIndicators: Bool = true
  
  @Binding public var scrollOffset: CGPoint
  @ViewBuilder public var content: (ScrollViewProxy) -> Content
  
  @Namespace public var coordinateSpaceName: Namespace.ID
  
  public init(
    _ axes: Axis.Set = .vertical,
    showsIndicators: Bool = true,
    scrollOffset: Binding<CGPoint>,
    @ViewBuilder content: @escaping (ScrollViewProxy) -> Content
  ) {
    self.axes = axes
    self.showsIndicators = showsIndicators
    self._scrollOffset = scrollOffset
    self.content = content
  }
  
  public var body: some View {
    ScrollView(axes, showsIndicators: showsIndicators) {
      ScrollViewReader { scrollViewProxy in
        content(scrollViewProxy)
          .background {
            GeometryReader { geometryProxy in
              Color.clear
                .preference(
                  key: ScrollOffsetPreferenceKey.self,
                  value: CGPoint(
                    x: -geometryProxy.frame(in: .named(coordinateSpaceName)).minX,
                    y: -geometryProxy.frame(in: .named(coordinateSpaceName)).minY
                  )
                )
            }
          }
      }
    }
    .coordinateSpace(name: coordinateSpaceName)
    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
      scrollOffset = value
    }
  }
  
  private struct ScrollOffsetPreferenceKey: SwiftUI.PreferenceKey {
    static var defaultValue: CGPoint { .zero }
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
      value.x += nextValue().x
      value.y += nextValue().y
    }
  }
}

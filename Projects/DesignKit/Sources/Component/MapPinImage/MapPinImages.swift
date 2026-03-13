//
//  MapPinImages.swift
//  DesignKit
//
//  Created by Jiyeon on 3/13/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI

@MainActor
public enum MapPinImages {
  
  public static func activeMapPinImage(status: BloomStatus, type: MapSpotType) -> UIImage {
    return render(MapPinView(state: .active, status: status, type: type))
  }
  
  public static func inactiveMapPinImage(status: BloomStatus, type: MapSpotType) -> UIImage {
    return render(MapPinView(state: .inactive, status: status, type: type))
  }
  
  private static func render<V: View>(_ view: V) -> UIImage {
    let renderer = ImageRenderer(content: view)
    renderer.scale = UIScreen.main.scale
    return renderer.uiImage ?? UIImage()
  }
}

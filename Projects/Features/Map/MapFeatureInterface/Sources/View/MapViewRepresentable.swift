//
//  MapViewRepresentable.swift
//  MapFeature
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

import NMapsMap

struct MapViewRepresentable: UIViewRepresentable {
  private let locationManager = CLLocationManager()
  // MARK: - UI
  
  private let mapView: NMFNaverMapView = {
    let view = NMFNaverMapView()
    view.showZoomControls = false
    view.mapView.positionMode = .direction
    view.mapView.zoomLevel = 13
    return view
  }()
  
  // MARK: - UIViewRepresentable Method
  
  func makeUIView(context: Context) -> NMFNaverMapView {
    
    return mapView
  }
  
  func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  
  class Coordinator: NSObject {
    var parent: MapViewRepresentable
    
    init(_ parent: MapViewRepresentable) {
      self.parent = parent
    }
    
  }
}

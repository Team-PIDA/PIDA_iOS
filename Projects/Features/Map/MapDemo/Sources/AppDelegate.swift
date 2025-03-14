//
//  MapDemoApp.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct MapDemoApp: App {
    let feature = MapFeature()

    var body: some Scene {
        WindowGroup {
            MapView(store: feature.store)
        }
    }
}


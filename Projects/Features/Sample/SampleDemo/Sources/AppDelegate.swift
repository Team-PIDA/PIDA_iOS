//
//  SampleDemoApp.swift
//
//  Sample
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct SampleDemoApp: App {
    let feature = SampleFeature()

    var body: some Scene {
        WindowGroup {
            SampleView(store: feature.store)
        }
    }
}


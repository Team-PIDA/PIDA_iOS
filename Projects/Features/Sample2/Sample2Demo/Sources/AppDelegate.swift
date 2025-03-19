//
//  Sample2DemoApp.swift
//
//  Sample2
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct Sample2DemoApp: App {
    let feature = Sample2Feature()

    var body: some Scene {
        WindowGroup {
            Sample2View(store: feature.store)
        }
    }
}


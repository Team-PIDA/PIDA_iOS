//
//  Sample1DemoApp.swift
//
//  Sample1
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct Sample1DemoApp: App {
    let feature = Sample1Feature()

    var body: some Scene {
        WindowGroup {
            Sample1View(store: feature.store)
        }
    }
}


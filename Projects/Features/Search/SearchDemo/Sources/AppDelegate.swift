//
//  SearchDemoApp.swift
//
//  Search
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct SearchDemoApp: App {
    let feature = SearchFeature()

    var body: some Scene {
        WindowGroup {
            SearchView(store: feature.store)
        }
    }
}


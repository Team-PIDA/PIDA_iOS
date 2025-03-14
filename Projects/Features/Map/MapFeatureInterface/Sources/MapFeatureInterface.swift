//
//  MapInterface.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public protocol MapInterface {
  func startView(store: StoreOf<MapReducer>) -> AnyView
}

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
  var reducer: StoreOf<MapReducer> { get }
  func startView() -> AnyView
}


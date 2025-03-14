//
//  MapInterface.swift
//
//  Map
//
//  Created by JiYeon
//

import ComposableArchitecture

public protocol MapInterface {
    var store: StoreOf<MapReducer> { get }
}

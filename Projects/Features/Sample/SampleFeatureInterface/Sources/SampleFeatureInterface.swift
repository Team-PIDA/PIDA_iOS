//
//  SampleInterface.swift
//
//  Sample
//
//  Created by JiYeon
//

import ComposableArchitecture

public protocol SampleInterface {
    var store: StoreOf<SampleReducer> { get }
}

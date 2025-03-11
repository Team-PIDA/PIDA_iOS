//
//  SampleInterface.swift
//
//  Sample
//
//  Created by yongin
//

import ComposableArchitecture

public protocol SampleInterface {
    var store: StoreOf<SampleReducer> { get }
}

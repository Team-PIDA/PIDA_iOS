//
//  MapUsecCase.swift
//
//  Map
//
//  Created by JiYeon
//

import Foundation

public protocol MapUseCase {
    func execute() async throws -> Void
}

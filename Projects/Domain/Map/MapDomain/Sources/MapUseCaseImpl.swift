//
//  MapUseCaseImpl.swift
//
//  Map
//
//  Created by JiYeon
//

import Foundation
import MapDomainInterface

public struct MapUseCaseImpl: MapUseCase {
    private let repository: MapRepository

    public init(
        repository: MapRepository
    ) {
        self.repository = repository
    }

    public func execute() async throws -> Void {
        
    }
}

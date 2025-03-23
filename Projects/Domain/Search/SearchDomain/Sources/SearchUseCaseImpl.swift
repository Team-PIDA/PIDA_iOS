//
//  SearchUseCaseImpl.swift
//
//  Search
//
//  Created by JiYeon
//

import Foundation
import SearchDomainInterface

public struct SearchUseCaseImpl: SearchUseCase {
    private let repository: SearchRepository

    public init(
        repository: SearchRepository
    ) {
        self.repository = repository
    }

    public func execute() async throws -> Void {
        
    }
}

//
//  Sample1UseCaseImpl.swift
//
//  Sample1
//
//  Created by JiYeon
//

import Foundation
import Sample1DomainInterface

public struct Sample1UseCaseImpl: Sample1UseCase {
    private let repository: Sample1Repository

    public init(
        repository: Sample1Repository
    ) {
        self.repository = repository
    }

    public func execute() async throws -> Void {
        
    }
}

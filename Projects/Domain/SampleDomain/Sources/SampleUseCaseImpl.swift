//
//  SampleUseCaseImpl.swift
//
//  Sample
//
//  Created by yongin
//

import Foundation
import SampleDomainInterface

public struct SampleUseCaseImpl: SampleUseCase {
    private let repository: SampleRepository

    public init(
        repository: SampleRepository
    ) {
        self.repository = repository
    }

    public func execute() async throws -> Void {
        
    }
}

//
//  SampleUsecCase.swift
//
//  Sample
//
//  Created by JiYeon
//

import Foundation

public protocol SampleUseCase {
    func execute() async throws -> Void
}

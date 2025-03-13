//
//  SampleUsecCase.swift
//
//  Sample
//
//  Created by yongin
//

import Foundation

public protocol SampleUseCase {
    func execute() async throws -> Void
}

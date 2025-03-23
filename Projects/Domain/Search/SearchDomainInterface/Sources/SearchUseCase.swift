//
//  SearchUsecCase.swift
//
//  Search
//
//  Created by JiYeon
//

import Foundation

public protocol SearchUseCase {
    func execute() async throws -> Void
}

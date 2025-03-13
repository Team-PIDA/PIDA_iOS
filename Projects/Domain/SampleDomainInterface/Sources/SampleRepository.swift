//
//  SampleRepository.swift
//
//  Sample
//
//  Created by yongin
//

import Foundation

public protocol SampleRepository {
    func fetchData() async throws -> Void
}

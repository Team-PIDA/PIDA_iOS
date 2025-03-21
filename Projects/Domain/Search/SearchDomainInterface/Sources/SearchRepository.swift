//
//  SearchRepository.swift
//
//  Search
//
//  Created by JiYeon
//

import Foundation

public protocol SearchRepository {
    func fetchData() async throws -> Void
}

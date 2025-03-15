//
//  MapRepository.swift
//
//  Map
//
//  Created by JiYeon
//

import Foundation

public protocol MapRepository {
    func fetchData() async throws -> Void
}

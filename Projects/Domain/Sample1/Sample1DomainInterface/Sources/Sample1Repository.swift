//
//  Sample1Repository.swift
//
//  Sample1
//
//  Created by JiYeon
//

import Foundation

public protocol Sample1Repository {
    func fetchData() async throws -> Void
}

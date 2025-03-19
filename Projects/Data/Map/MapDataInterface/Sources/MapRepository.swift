//
//  MapRepositoryInterface.swift
//  MapDataInterface
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol MapRepository {
    func fetchData() async throws -> Void
}

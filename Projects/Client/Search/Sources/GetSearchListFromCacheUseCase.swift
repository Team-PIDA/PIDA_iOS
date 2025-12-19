//
//  GetSearchListFromCacheUseCase.swift
//  SearchDomainInterface
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol GetSearchListFromCacheUseCase {
    func execute() async throws -> [SearchListCellEntity]
}

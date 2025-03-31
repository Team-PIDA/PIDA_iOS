//
//  FetchRecentSearchUseCase.swift
//  SearchDomainInterface
//
//  Created by Jiyeon on 3/31/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol FetchRecentSearchUseCase {
  func execute() async throws -> [SearchListCellEntity]
}

//
//  DTO.swift
//  Networker
//
//  Created by 조용인 on 3/18/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

protocol DTO: Decodable {
    associatedtype Entity
    func toEntity() throws -> Entity
}

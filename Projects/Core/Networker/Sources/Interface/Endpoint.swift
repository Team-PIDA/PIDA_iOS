//
//  Endpoint.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

struct EmptyResponse: Codable {}

public struct Endpoint<R>: APIRequestable where R: Decodable {
    public typealias Response = R
    
    public let headers: HTTPHeaders
    public let method: HTTPMethod
    public let baseURL: URL?
    public let path: String
    public let parameters: HTTPRequestParameter?
    
    public init(
        headers: HTTPHeaders = ["Content-Type": "application/json"],
        method: HTTPMethod,
        baseURL: String,
        path: String,
        parameters: HTTPRequestParameter? = nil
    ) {
        self.headers = headers
        self.method = method
        self.baseURL = URL(string:baseURL)
        self.path = path
        self.parameters = parameters
    }
}

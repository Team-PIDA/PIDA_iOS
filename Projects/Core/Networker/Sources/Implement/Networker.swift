//
//  Networker.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Utility

public struct Networker: NetworkProtocol, Sendable {
  
  private let session: URLSession
  
  public init(
    session: URLSession = .shared
  ) {
    self.session = session
  }
  
  public func execute<E: APIRequestable>(
    with endpoint: E,
    timeout: TimeInterval = 30.0
  ) async throws -> E.Response where E.Response: Decodable & Sendable {
    try await withThrowingTaskGroup(of: E.Response.self) { group in
      group.addTask { // 실제 네트워크 통신 Task
        let request = try endpoint.toURLRequest()
        let (data, response) = try await self.session.data(for: request)
        return try self.handleResponse(data: data, response: response, endpoint: endpoint)
      }
      
      group.addTask { // 타임아웃 체크 전용 Task
        try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
        throw NetworkError.timeout(timeout)
      }
      
      do {
        if let result = try await group.next() { // 먼저 완료되는 task 결과 처리 후, 나머지는 모두 취소시킴.
          group.cancelAll()
          return result
        } else {
          throw FoundationError.taskFailed
        }
      } catch {
        group.cancelAll()
        throw FoundationError.taskCancelled
      }
    }
  }
  
  public func executeWithTask<E: APIRequestable>(
    with endpoint: E,
    timeout: TimeInterval = 30.0
  ) -> Task<E.Response, Error> where E.Response: Decodable & Sendable {
    return Task {
      try Task.checkCancellation() // 시작 전 취소 확인
      
      return try await withThrowingTaskGroup(of: E.Response.self) { group in
        
        group.addTask { // 실제 네트워크 통신 Task
          try Task.checkCancellation() // 요청 전 취소 확인
          let request = try endpoint.toURLRequest()
          try Task.checkCancellation() // 요청 직전 취소 확인
          let (data, response) = try await self.session.data(for: request)
          try Task.checkCancellation() // 응답 후 취소 확인
          return try self.handleResponse(data: data, response: response, endpoint: endpoint)
        }
        
        group.addTask { // 타임아웃 태스크
          try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
          throw NetworkError.timeout(timeout)
        }
        
        do {
          if let result = try await group.next() { // 먼저 완료되는 task 결과 처리 후, 나머지는 모두 취소시킴
            group.cancelAll()
            return result
          } else {
            throw FoundationError.taskFailed
          }
        } catch {
          group.cancelAll()
          throw error
        }
      }
    }
  }
}

extension Networker {
  fileprivate func handleResponse<R: Decodable & Sendable>(
    data: Data,
    response: URLResponse,
    endpoint: any APIRequestable
  ) throws -> R {
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw  FoundationError.failedToCasting(from: URLResponse.self, to: HTTPURLResponse.self)
    }
    
    guard (200..<300).contains(httpResponse.statusCode) else {
      do {
        let error = try JSONDecoder().decode(APIResponse<ErrorResponse>.self, from: data)
        switch httpResponse.statusCode {
        case 400...599: throw NetworkError.serverError(message: error.data.message, code: error.status)
        default: throw NetworkError.invalidStatusCode(httpResponse.statusCode)
        }
      } catch {
        throw NetworkError.invalidStatusCode(httpResponse.statusCode)
      }
    }
    
    do {
      let decoder = JSONDecoder()
      let response = try decoder.decode(R.self, from: data)
      return response
    } catch {
      throw FoundationError.failedToDecode(data)
    }
  }
}

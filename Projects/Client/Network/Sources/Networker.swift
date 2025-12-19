//
//  Networker.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Shared

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
        return try await self.handleResponse(data: data, response: response, endpoint: endpoint)
      }
      
      group.addTask { // 타임아웃 체크 전용 Task
        try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
        throw throwError(NetworkError.timeout(timeout), endpoint: endpoint)
      }
      
      do {
        if let result = try await group.next() { // 먼저 완료되는 task 결과 처리 후, 나머지는 모두 취소시킴.
          group.cancelAll()
          return result
        } else {
          throw throwError(
            FoundationError.taskFailed,
            endpoint: endpoint
          )
        }
      } catch let error as NetworkError {
        group.cancelAll()
        throw error
      } catch let error as FoundationError {
        group.cancelAll()
        throw error
      }
      catch {
        group.cancelAll()
        throw throwError(
          FoundationError.taskCancelled,
          endpoint: endpoint
        )
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
          return try await self.handleResponse(data: data, response: response, endpoint: endpoint)
        }
        
        group.addTask { // 타임아웃 태스크
          try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
          throw throwError(
            NetworkError.timeout(timeout),
            endpoint: endpoint
          )
        }
        
        do {
          if let result = try await group.next() { // 먼저 완료되는 task 결과 처리 후, 나머지는 모두 취소시킴
            group.cancelAll()
            return result
          } else {
            throw throwError(
              FoundationError.taskFailed,
              endpoint: endpoint
            )
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
  ) async throws -> R {
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw throwError(
        FoundationError.failedToCasting(
          from: URLResponse.self,
          to: HTTPURLResponse.self
        ),
        endpoint: endpoint
      )
    }
    
    // 401에러면서 토큰 재발급 요청이 아닌 경우 재발급 요청 수행
    if httpResponse.statusCode == 401 && !endpoint.isRefreshToken {
      return try await refreshTokenAndRetry(for: endpoint)
    }
    
    guard (200..<300).contains(httpResponse.statusCode) else {
      let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
      switch httpResponse.statusCode {
      case 400...599:
        throw throwError(
          NetworkError.serverError(
            message: errorResponse.data.message,
            code: errorResponse.status,
            className: errorResponse.data.errorClassName
          ),
          endpoint: endpoint
        )
      default:
        throw throwError(
          NetworkError.invalidStatusCode(
            httpResponse.statusCode
          ),
          endpoint: endpoint
        )
      }
    }
    
    do {
      let decoder = JSONDecoder()
      let response = try decoder.decode(APIResponse<R>.self, from: data)
      responseSuccess(response, endpoint: endpoint)
      return response.data
    } catch {
      throw throwError(
        FoundationError.failedToDecode(data),
        endpoint: endpoint
      )
    }
  }
  
  private func refreshTokenAndRetry<R: Decodable & Sendable>(
    for endpoint: any APIRequestable
  ) async throws -> R {
    do {
      guard let newToken = try await DefaultTokenRefresher.refreshToken() else {
        throw throwError(TokenError.expiredToken, endpoint: endpoint)
      }
      // 기존 작업 재요청
      var newRequest = try endpoint.toURLRequest()
      newRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
      
      let (newData, newResponse) = try await self.session.data(for: newRequest)
      return try await self.handleResponse(
        data: newData,
        response: newResponse,
        endpoint: endpoint
      )
    } catch {
      throw throwError(TokenError.expiredToken, endpoint: endpoint)
    }
  }
  
}

extension Networker {
  fileprivate func responseSuccess<R>(_ response: APIResponse<R>, endpoint: any APIRequestable) {
    print("""
          ==========================================
          ============== ✅ SUCCESS ================
          ✔️ URL: \(endpoint.path)
          ✔️ Data: \(response.data)
          ==========================================
          """)
  }
  
  fileprivate func throwError(_ error: Error, endpoint: any APIRequestable) -> Error {
    var description: String = error.localizedDescription
    if let error = error as? NetworkError {
      description = error.errorDescription
    } else if let error = error as? FoundationError {
      description = error.errorDescription
    } else if let error = error as? TokenError {
      description = error.errorDescription
    }
    print("""
          =========================================
          ============== 🚨 ERROR==================
          ✔️ URL: \(endpoint.path)
          ✔️ Message: \(description)
          =========================================
          """)
    return error
  }
}

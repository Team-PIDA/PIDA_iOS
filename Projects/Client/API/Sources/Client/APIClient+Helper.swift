//
//  APIClient+Helper.swift
//  NetworkClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import Shared
import LoggerClient
import ComposableArchitecture

extension APIClient {
  static func handleResponse<R: Decodable & Sendable>(
    data: Data,
    response: URLResponse,
    endpoint: any APIRequestable
  ) async throws -> R {
    guard let response = response as? HTTPURLResponse else {
      throw Self.throwError(
        FoundationError.failedToCasting(
          from: URLResponse.self,
          to: HTTPURLResponse.self
        ),
        endpoint: endpoint
      )
    }
    
    // 401에러면서 토큰 재발급 요청이 아닌 경우 재발급 요청 수행
    if response.statusCode == 401 && !endpoint.isRefreshToken {
      return try await reissueTokenIfNeeded(for: endpoint)
    }
    
    /// `statusCode`에 따른 분기 처리
    switch response.statusCode {
    case 200...299:
      let response = try data.decode(APIResponse<R>.self)
      responseSuccess(response, endpoint: endpoint)
      return response.data
    case 400...599:
      let errorResponse = try data.decode(ErrorResponse.self)
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
          response.statusCode
        ),
        endpoint: endpoint
      )
    }
  }
  
  public static func reissueTokenIfNeeded<R: Decodable & Sendable>(
    for endpoint: any APIRequestable
  ) async throws -> R {
    do {
      guard let newToken = try await Self.refreshToken() else {
        throw throwError(TokenError.expiredToken, endpoint: endpoint)
      }
      // 기존 작업 재요청
      var newRequest = try endpoint.toURLRequest()
      newRequest.setValue(
        "Bearer \(newToken)",
        forHTTPHeaderField: "Authorization"
      )
      
      let (newData, newResponse) = try await URLSession.shared.data(for: newRequest)
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

extension APIClient {
  static var checkTimeOut: (TimeInterval) async throws -> Data = { timeout in
    try await Task.sleep(for: .seconds(timeout))
    throw DownloadError.timeout(timeout)
  }
  
  static func sendRequestLog(_ request: URLRequest) {
    @Dependency(\.loggerClient) var loggerClient
    var message = """
    🚀 [\(request.httpMethod ?? "none")] \(request.url?.absoluteString ?? "none")
    """
    
    if let body = request.httpBody,
       let bodyString = String(data: body, encoding: .utf8) {
      message += "\n- Body: \(bodyString)"
    }
    
    loggerClient.log(message: message, level: .info)
  }
  
  static func responseSuccess<R>(
    _ response: APIResponse<R>,
    endpoint: any APIRequestable
  ) {
    @Dependency(\.loggerClient) var loggerClient
    
    let message = """
    ✅ [\(response.status)] \(endpoint.method) \(endpoint.path)
    - TimeStamp: \(response.timestamp)
    - Data: \(response.data)
    """
    loggerClient.log(message, .info)
  }
  
  
  static func throwError(
    _ error: Error,
    endpoint: (any APIRequestable)? = nil
  ) -> Error {
    @Dependency(\.loggerClient) var loggerClient
    
    var description: String = error.localizedDescription
    if let error = error as? NetworkError {
      description = error.errorDescription
    } else if let error = error as? FoundationError {
      description = error.errorDescription
    } else if let error = error as? TokenError {
      description = error.errorDescription
    } else if let error = error as? DownloadError {
      description = error.errorDescription
    }
    
    let message = """
          ============== 🚨 ERROR==================
          ✔️ URL: \(endpoint?.path ?? "N/A")
          ✔️ Message: \(description)
          =========================================
          """
    loggerClient.log(message, .error)
    return error
  }
}

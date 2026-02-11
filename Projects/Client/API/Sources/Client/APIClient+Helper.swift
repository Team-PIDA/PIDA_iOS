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
        url: response.url?.absoluteString,
        errorResponse: errorResponse,
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
    
    let requestInfo = RequestLogInfo(request: request)
    loggerClient.logLoggable(requestInfo, .info)
  }
  
  static func responseSuccess<R>(
    _ response: APIResponse<R>,
    endpoint: any APIRequestable
  ) {
    @Dependency(\.loggerClient) var loggerClient
    
    let responseInfo = ResponseLogInfo(
      status: response.status,
      method: endpoint.method.rawValue,
      path: endpoint.path,
      timestamp: response.timestamp,
      data: String(describing: response.data)
    )
    
    loggerClient.logLoggable(responseInfo, .info)
  }
  
  
  static func throwError(
    _ error: Error,
    url: String? = nil,
    errorResponse: ErrorResponse? = nil,
    endpoint: (any APIRequestable)? = nil
  ) -> Error {
    @Dependency(\.loggerClient) var loggerClient
    
    guard let endpoint = endpoint else {
      let errorInfo = ErrorLogInfo(
        error: error,
        path: "Unknown",
        headers: "none"
      )
      loggerClient.logLoggable(errorInfo, .error)
      return error
    }
    
    let errorInfo = ErrorLogInfo(
      error: error,
      path: endpoint.path,
      method: endpoint.method.rawValue,
      statusCode: errorResponse?.status,
      timestamp: errorResponse?.timestamp,
      url: url,
      parameters: endpoint.parameters.map { String(describing: $0) },
      headers: String(describing: endpoint.headers)
    )
    
    loggerClient.logLoggable(errorInfo, .error)
    return error
  }
}

//
//  APIClient+Internal.swift
//  NetworkClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import Shared

extension APIClient {
  static func internalExecute<T: APIRequestable>(
    _ endpoint: T
  ) async throws -> T.Response where T.Response: Decodable & Sendable {
    try await withThrowingTaskGroup(of: T.Response.self) { group in
      group.addTask { // 실제 네트워크 통신 Task
        let request = try endpoint.toURLRequest()
        sendRequestLog(request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return try await self.handleResponse(data: data, response: response, endpoint: endpoint)
      }
      group.addTask { // 타임아웃 체크 전용 Task
        try await Task.sleep(nanoseconds: UInt64(10.0 * 1_000_000_000))
        throw throwError(NetworkError.timeout(10.0), endpoint: endpoint)
      }
      
      do {
        if let result = try await group.next() {
          group.cancelAll()
          return result
        } else {
          throw throwError(
            FoundationError.taskFailed,
            endpoint: endpoint
          )
        }
      } catch is CancellationError {
        throw throwError(
          FoundationError.taskCancelled,
          endpoint: endpoint
        )
      } catch {
        throw error
      }
    }
  }
  
  static func internalUpload(
    _ url: String,
    _ data: Data
  ) async throws -> Void {
    let maxRetryCount = 3
    var lastError: Error?

    for attempt in 1...maxRetryCount {
      do {
        try await performUpload(url: url, data: data)
        return // 성공 시 즉시 반환
      } catch {
        lastError = error
        if attempt < maxRetryCount {
          try? await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
        }
      }
    }

    // 3회 모두 실패
    throw lastError ?? throwError(FoundationError.taskFailed)
  }

  private static func performUpload(
    url: String,
    data: Data
  ) async throws -> Void {
    guard let validURL = URL(string: url) else {
      throw throwError(NetworkError.customError(message: "Invalid upload URL"))
    }

    try await withThrowingTaskGroup(of: Void.self) { group in
      group.addTask {
        var request = URLRequest(url: validURL)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.setValue("", forHTTPHeaderField: "Expect")

        let (_, response) = try await URLSession.shared.upload(for: request, from: data)

        guard let response = response as? HTTPURLResponse else {
          throw Self.throwError(
            FoundationError.failedToCasting(
              from: URLResponse.self,
              to: HTTPURLResponse.self
            )
          )
        }

        switch response.statusCode {
        case 200...299: break
        default:
          throw throwError(
            NetworkError.customError(message: response.description)
          )
        }
      }

      group.addTask {
        try await Task.sleep(nanoseconds: UInt64(10.0 * 1_000_000_000))
        throw throwError(NetworkError.timeout(10.0))
      }

      do {
        if let _ = try await group.next() {
          group.cancelAll()
          return
        } else {
          throw throwError(FoundationError.taskFailed)
        }
      } catch is CancellationError {
        group.cancelAll()
        throw throwError(FoundationError.taskCancelled)
      }
    }
  }
  
  static func internalDownload(
    _ url: String
  ) async throws -> Data {
    guard let validURL = URL(string: url) else {
      throw throwError(DownloadError.unknown)
    }

    return try await withThrowingTaskGroup(of: Data.self) { group in
      group.addTask {
        let request = URLRequest(url: validURL)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
          throw Self.throwError(
            FoundationError.failedToCasting(
              from: URLResponse.self,
              to: HTTPURLResponse.self
            )
          )
        }
        
        switch response.statusCode {
        case 200...299:
          if data.isEmpty { throw throwError(DownloadError.emptyData) }
        default: throw throwError(DownloadError.unknown)
        }
        return data
      }
      
      group.addTask(operation: { try await Self.checkTimeOut(10) })
      
      do {
        if let result = try await group.next() {
          group.cancelAll()
          return result
        } else {
          throw throwError(DownloadError.unknown)
        }
      } catch is CancellationError {
        group.cancelAll()
        throw throwError(DownloadError.cancelled)
      } catch {
        group.cancelAll()
        throw throwError(error)
      }
    }
  }
}

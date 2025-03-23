//
//  AppleLoginManager.swift
//  Utility
//
//  Created by Jiyeon on 3/23/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthenticationServices
import UIKit

final class AppleLoginManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  private var continuation: CheckedContinuation<String?, Error>?
  private var window: UIWindow?
  
  /// 비동기로 애플 로그인을 수행합니다.
  /// - Parameters:
  ///   - scope: 요청할 사용자 정보 (예: [.fullName, .email])
  ///   - window: 로그인 UI를 표시할 UIWindow
  /// - Returns: 인증 코드(String?) (성공시) 또는 에러 발생
  func performAppleLogin(
    scope: [ASAuthorization.Scope],
    window: UIWindow?
  ) async throws -> String? {
    self.window = window
    
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = scope
    
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
    
    return try await withCheckedThrowingContinuation { continuation in
      self.continuation = continuation
    }
  }
  
  // MARK: - ASAuthorizationControllerDelegate
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
       let codeData = appleCredential.authorizationCode,
       let authCode = String(data: codeData, encoding: .utf8) {
      resume(value: authCode)
    } else {
      resume(value: nil)
    }
    
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    resumeWithError(error)
  }
  
  // MARK: - Resume Continuation
  
  private func resume(value: String?) {
    guard let continuation = self.continuation else { return }
    self.continuation = nil
    continuation.resume(returning: value)
  }
  
  private func resumeWithError(_ error: Error) {
    guard let continuation = self.continuation else { return }
    self.continuation = nil
    continuation.resume(throwing: error)
  }
  
  
  // MARK: - ASAuthorizationControllerPresentationContextProviding
  
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return window ?? UIWindow()
  }
}




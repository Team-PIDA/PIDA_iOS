//
//  AppleLoginHelper.swift
//  AuthFeature
//
//  Created by Jiyeon on 3/22/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit

public enum AppleLoginHelper {
  public static func requestAuthorization() async throws -> String? {
    let window = await MainActor.run { UIApplication.shared.currentWindow }
    return try await AppleLoginManager().performAppleLogin(
      scope: [.fullName, .email],
      window: window
    )
  }
}

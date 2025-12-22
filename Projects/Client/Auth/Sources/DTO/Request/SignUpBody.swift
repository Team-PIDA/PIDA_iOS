//
//  SignUpBody.swift
//  AuthClient
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct SignUpBody: Encodable {
  let email: String
  let name: String
  
  public init(email: String, name: String) {
    self.email = email
    self.name = name
  }
}

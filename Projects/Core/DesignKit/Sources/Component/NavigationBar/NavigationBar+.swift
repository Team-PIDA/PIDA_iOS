//
//  NavigationBar+.swift
//  DesignKit
//
//  Created by 조용인 on 3/25/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import SwiftUI

public struct NavigationGestureSupportView: UIViewControllerRepresentable {
  
  public init() { }
  
  public func makeUIViewController(context: Context) -> UIViewController {
    let controller = UIViewController()
    Task { @MainActor in
      if let navigationController = controller.navigationController {
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        navigationController.interactivePopGestureRecognizer?.delegate = context.coordinator
      }
    }
    return controller
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  public class Coordinator: NSObject, UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      true
    }
  }
}

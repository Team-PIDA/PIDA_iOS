//
//  Modules.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public protocol ModuleRepresentable { var layer: String { get } }

public enum Module {
  case feature(Feature)
  case domain(Domain, isInterface: Bool? = false)
  case data(Data, isInterface: Bool? = false)
  case common(Common)
  case spm(SPM)
}

public enum Feature: ModuleRepresentable {
  public var layer: String { String(describing: Self.self) }
  // 예시: case Home, Login, Profile, Settings
  case Map
  case Search
  case Setting
  case FlowerSpotDetail
  case Auth
  case Blooming
}

public enum Domain: ModuleRepresentable {
  // 예시: case Auth, User, Product, Order
  case Search
  case Setting
  case FlowerSpot
  case Auth
  case User
  case Blooming
  public var layer: String { String(describing: Self.self) }
}

public enum Data: ModuleRepresentable {
  // 예시: case Auth, User, Product, Order
  case Search
  case Setting
  case FlowerSpot
  case Auth
  case User
  case Blooming
  public var layer: String { String(describing: Self.self) }
}

public enum Common: ModuleRepresentable {
  case KeyChain
  case UserDefault
  case Utility
  case Networker
  case DesignKit
  case Cache
  public var layer: String { String(describing: self) }
}

public enum SPM: String, ModuleRepresentable {
  case TCA = "ComposableArchitecture"
  case Dependencies = "Dependencies"
  case NMap = "NMapsMap"
  case Lottie = "Lottie"
  case DotLottie = "DotLottie"
  public var layer: String { "SPM" }
}

//
//  TargetDependency+.swift
//  Config
//
//  Created by 조용인 on 3/9/25.
//

import Foundation
import ProjectDescription

public enum Layer: String {
  case domain = "Domain"
  case data = "Data"
  case feature = "Feature"
  case app = "PIDA"
}

public enum Feature: String {
  case map = "Map"
  case search = "Search"
  case setting = "Setting"
  case flowerSpot = "FlowerSpot"
}


public enum ExternalDependency: String {
  case TCA = "ComposableArchitecture"
  case NMap = "NMapsMap"
}

public enum InternalTarget: String {
  case keyChain = "KeyChain"
  case network = "Networker"
  case designKit = "DesignKit"
  case utility = "Utility"
  case thirdParty = "ThirdParty"
  case userDefault = "UserDefault"
  case cache = "Cache"
  
  public var path: String {
    var root = "./Projects/"
    switch self {
    case .network, .designKit, .cache:
      root += "Core/"
    case .keyChain, .utility, .thirdParty, .userDefault:
      root += "Shared/"
    }
    return root + self.rawValue
  }
}

public enum InternalFramework: String {
  case core = "Core"
  case shared = "Shared"
  case thirdParty = "ThirdParty"
}

public protocol PIDADependency {
  static func `internal`(name: InternalTarget) -> TargetDependency
  static func external(externalDependency: ExternalDependency) -> TargetDependency
  static func projectWithLayer(feature: Feature, layer: Layer, isInterface: Bool) -> TargetDependency
  static func projectWithFeature(feature: Feature, inInterface: Bool) -> TargetDependency
  static func projectWithFramework(framework: InternalFramework) -> TargetDependency
}

extension PIDADependency {
  public static func projectWithLayer(feature: Feature, layer: Layer, isInterface: Bool = true) -> TargetDependency {
    let featureName = feature.rawValue
    let layerName = layer.rawValue
    let folderName = isInterface ? "Interface" : ""
    return .project(
      target: featureName + layerName + folderName,
      path: .relativeToRoot("./Projects/\(layerName)/\(featureName)/\(featureName)\(layerName)\(folderName)")
    )
  }
  
  public static func projectWithFeature(feature: Feature, inInterface: Bool = false) -> TargetDependency {
    let featureName = feature.rawValue
    let folderName = inInterface ? "Interface" : ""
    return .project(
      target: feature.rawValue + "Feature" + folderName,
      path: .relativeToRoot("./Projects/Features/\(featureName)")
    )
  }
  
  public static func projectWithFramework(framework: InternalFramework) -> TargetDependency {
    let path = framework == .thirdParty ? "./Projects/Shared/\(framework.rawValue)" : "./Projects/\(framework.rawValue)"
    return .project(
      target: framework.rawValue,
      path: .relativeToRoot(path)
    )
  }
  
  public static func `internal`(name: InternalTarget) -> TargetDependency {
    return .project(
      target: name.rawValue,
      path: .relativeToRoot(name.path)
    )
  }
  
  public static func external(externalDependency: ExternalDependency) -> TargetDependency {
    return .external(name: externalDependency.rawValue)
  }
}


extension TargetDependency {
  
  public struct Features: PIDADependency {
    public struct Map: PIDADependency {
      public static let Interface = Self.projectWithFeature(feature: .map, inInterface: true)
      public static let Implement = Self.projectWithFeature(feature: .map)
    }
    public struct Search: PIDADependency {
      public static let Interface = Self.projectWithFeature(feature: .search, inInterface: true)
      public static let Implement = Self.projectWithFeature(feature: .search)
    }
    public struct Setting: PIDADependency {
      public static let Interface = Self.projectWithFeature(feature: .setting, inInterface: true)
      public static let Implement = Self.projectWithFeature(feature: .setting)
    }
  }
  
  public struct Domain {
    public struct Search: PIDADependency {
      public static let Interface = Self.projectWithLayer(feature: .search, layer: .domain)
      public static let Implement = Self.projectWithLayer(feature: .search, layer: .domain, isInterface: false)
    }
    public struct Setting: PIDADependency {
      public static let Interface = Self.projectWithLayer(feature: .setting, layer: .domain)
      public static let Implement = Self.projectWithLayer(feature: .setting, layer: .domain, isInterface: false)
    }
    public struct FlowerSpot: PIDADependency {
      public static let Interface = Self.projectWithLayer(feature: .flowerSpot, layer: .domain)
      public static let Implement = Self.projectWithLayer(feature: .flowerSpot, layer: .domain, isInterface: false)
    }
  }
  
  public struct Data {
    public struct Search: PIDADependency {
      public static let Interface = Self.projectWithLayer(feature: .search, layer: .data)
      public static let Implement = Self.projectWithLayer(feature: .search, layer: .data, isInterface: false)
    }
    public struct Setting: PIDADependency {
      public static let Interface = Self.projectWithLayer(feature: .setting, layer: .data)
      public static let Implement = Self.projectWithLayer(feature: .setting, layer: .data, isInterface: false)
    }
    public struct FlowerSpot: PIDADependency {
      public static let Interface = Self.projectWithLayer(feature: .flowerSpot, layer: .data)
      public static let Implement = Self.projectWithLayer(feature: .flowerSpot, layer: .data, isInterface: false)
    }
  }
  
  public struct InternalDependency: PIDADependency {
    public static let Core = Self.projectWithFramework(framework: .core)
    public static let Shared = Self.projectWithFramework(framework: .shared)
  }
  
  public struct CoreTarget: PIDADependency {
    public static let Networker = Self.internal(name: .network)
    public static let DesignKit = Self.internal(name: .designKit)
    public static let Cache = Self.internal(name: .cache)
  }
  
  public struct SharedTarget: PIDADependency {
    public static let KeyChain = Self.internal(name: .keyChain)
    public static let Utility = Self.internal(name: .utility)
    public static let ThirdParty = Self.projectWithFramework(framework: .thirdParty)
    public static let UserDefault = Self.internal(name: .userDefault)
  }
  
  public struct ThirdParty: PIDADependency {
    public static let TCA = Self.external(externalDependency: .TCA)
    public static let NMaps = Self.external(externalDependency: .NMap)
  }
}

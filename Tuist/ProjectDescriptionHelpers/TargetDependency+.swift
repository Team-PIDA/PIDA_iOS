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
    case features = "Features"
}

public enum Feature: String {
    case sample = "Sample"
}


public enum ExternalDependency: String {
    case TCA = "ComposableArchitecture"
}

public enum InternalDependency: String {
    case core = "Core"
    case keyChain = "KeyChain"
    case network = "Networker"
    case designKit = "DesignKit"
    case shared = "Shared"
    case utility = "Utility"
    case thirdParty = "3rdParty"
}

public protocol PIDADependency {
    static func `internal`(name: InternalDependency) -> TargetDependency
    static func external(externalDependency: ExternalDependency) -> TargetDependency
    static func projectWithLayer(feature: Feature, layer: Layer, isInterface: Bool) -> TargetDependency
    static func projectWithFeature(feature: Feature) -> TargetDependency
}

extension PIDADependency {
    public static func projectWithLayer(feature: Feature, layer: Layer, isInterface: Bool = true) -> TargetDependency {
        let featureName = feature.rawValue
        let layerName = layer.rawValue
        let postfix = isInterface ? "Interface" : ""
        let folderFullName = "\(featureName)\(layerName)\(postfix)"
        return .project(
            target: folderFullName,
            path: .relativeToRoot("\(layerName)/\(featureName)/\(folderFullName)")
        )
    }
    
    public static func projectWithFeature(feature: Feature) -> TargetDependency {
        let featureName = feature.rawValue
        return .project(
            target: feature.rawValue,
            path: .relativeToRoot("./Features/\(featureName)")
        )
    }
    
    public static func `internal`(name: InternalDependency) -> TargetDependency {
      return .target(name: name.rawValue)
    }
    
    public static func external(externalDependency: ExternalDependency) -> TargetDependency {
        return .external(name: externalDependency.rawValue)
    }
}


extension TargetDependency {
    
    public struct Features: PIDADependency {
        static let Sample = Self.projectWithFeature(feature: .sample)
    }
    
    public struct Domain { }
    
    public struct Data { }
    
    public struct Core: PIDADependency {
        static let KeyChain = Self.internal(name: .keyChain)
        static let Network = Self.internal(name: .network)
        static let DesignKit = Self.internal(name: .designKit)
    }
    
    public struct Shared: PIDADependency {
        static let Utility = Self.internal(name: .utility)
        static let ThirdParty = Self.internal(name: .thirdParty)
    }
    
    public struct ThirdParty: PIDADependency {
        static let TCA = Self.external(externalDependency: .TCA)
    }
}

public extension TargetDependency.Domain {
    struct Sample: PIDADependency {
        static let Interface = Self.projectWithLayer(feature: .sample, layer: .domain)
        static let Implement = Self.projectWithLayer(feature: .sample, layer: .domain, isInterface: false)
    }
    
}

public extension TargetDependency.Data {
    struct Sample: PIDADependency {
        static let Interface = Self.projectWithLayer(feature: .sample, layer: .data)
        static let Implement = Self.projectWithLayer(feature: .sample, layer: .data, isInterface: false)
    }
}

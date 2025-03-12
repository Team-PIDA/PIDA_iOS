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
}

public enum Feature: String {
    case sample = "Sample"
}


public enum ExternalDependency: String {
    case TCA = "ComposableArchitecture"
}

public enum InternalTarget: String {
    case keyChain = "KeyChain"
    case network = "Networker"
    case designKit = "DesignKit"
    case utility = "Utility"
    case thirdParty = "ThirdParty"
    
    public var path: String {
        switch self {
        case .keyChain:
            return "./Projects/Core/KeyChain"
        case .network:
            return "./Projects/Core/Networker"
        case .designKit:
            return "./Projects/Core/DesignKit"
        case .utility:
            return "./Projects/Shared/Utility"
        case .thirdParty:
            return "./Projects/Shared/ThirdParty"
        }
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
    static func projectWithFeature(feature: Feature) -> TargetDependency
    static func projectWithFramework(framework: InternalFramework) -> TargetDependency
}

extension PIDADependency {
    public static func projectWithLayer(feature: Feature, layer: Layer, isInterface: Bool = true) -> TargetDependency {
        let featureName = feature.rawValue
        let layerName = layer.rawValue
        let folderName = isInterface ? "Interface" : ""
        return .project(
            target: featureName + layerName + folderName,
            path: .relativeToRoot("./Projects/\(layerName)/\(featureName)\(layerName)\(folderName)")
        )
    }
    
    public static func projectWithFeature(feature: Feature) -> TargetDependency {
        let featureName = feature.rawValue
        return .project(
            target: feature.rawValue,
            path: .relativeToRoot("./Features/\(featureName)")
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
        public static let Sample = Self.projectWithFeature(feature: .sample)
    }
    
    public struct Domain {
        public struct Sample: PIDADependency {
            public static let Interface = Self.projectWithLayer(feature: .sample, layer: .domain)
            public static let Implement = Self.projectWithLayer(feature: .sample, layer: .domain, isInterface: false)
        }
    }
    
    public struct Data {
        public struct Sample: PIDADependency {
            public static let Interface = Self.projectWithLayer(feature: .sample, layer: .data)
            public static let Implement = Self.projectWithLayer(feature: .sample, layer: .data, isInterface: false)
        }
    }
    
    public struct InternalDependency: PIDADependency {
        public static let Core = Self.projectWithFramework(framework: .core)
        public static let Shared = Self.projectWithFramework(framework: .shared)
    }
    
    public struct CoreTarget: PIDADependency {
        public static let KeyChain = Self.internal(name: .keyChain)
        public static let Networker = Self.internal(name: .network)
        public static let DesignKit = Self.internal(name: .designKit)
    }
    
    public struct SharedTarget: PIDADependency {
        public static let Utility = Self.internal(name: .utility)
        public static let ThirdParty = Self.projectWithFramework(framework: .thirdParty)
    }
    
    public struct ThirdParty: PIDADependency {
        public static let TCA = Self.external(externalDependency: .TCA)
    }
}

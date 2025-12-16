//
//  DependencyComponent.swift
//  Config
//
//  Created by 조용인 on 3/9/25.
//

import Foundation
import ProjectDescription

extension TargetDependency {
  public struct Feature: TargetDependencyFactory {
    public static let Map = Self.project(.feature(.Map))
    
    public static let Search = Self.project(.feature(.Search))
    
    public static let Setting = Self.project(.feature(.Setting))
    
    public static let FlowerSpotDetail = Self.project(.feature(.FlowerSpotDetail))
    
    public static let Auth = Self.project(.feature(.Auth))
    
    public static let Blooming = Self.project(.feature(.Blooming))
  }
}

extension TargetDependency {
  public struct Domain: TargetDependencyFactory {
    public struct Search: TargetDependencyFactory {
      public static let Interface = Self.project(.domain(.Search, isInterface: true))
      public static let Implement = Self.project(.domain(.Search))
    }
    
    public struct Setting: TargetDependencyFactory {
      public static let Interface = Self.project(.domain(.Setting, isInterface: true))
      public static let Implement = Self.project(.domain(.Setting))
    }
    
    public struct FlowerSpot: TargetDependencyFactory {
      public static let Interface = Self.project(.domain(.FlowerSpot, isInterface: true))
      public static let Implement = Self.project(.domain(.FlowerSpot))
    }
    
    public struct Auth: TargetDependencyFactory {
      public static let Interface = Self.project(.domain(.Auth, isInterface: true))
      public static let Implement = Self.project(.domain(.Auth))
    }
    
    public struct User: TargetDependencyFactory {
      public static let Interface = Self.project(.domain(.User, isInterface: true))
      public static let Implement = Self.project(.domain(.User))
    }
    
    public struct Blooming: TargetDependencyFactory {
      public static let Interface = Self.project(.domain(.Blooming, isInterface: true))
      public static let Implement = Self.project(.domain(.Blooming))
    }
  }
  
  public struct Data: TargetDependencyFactory {
    public struct Search: TargetDependencyFactory {
      public static let Interface = Self.project(.data(.Search, isInterface: true))
      public static let Implement = Self.project(.data(.Search))
    }
    
    public struct Setting: TargetDependencyFactory {
      public static let Interface = Self.project(.data(.Setting, isInterface: true))
      public static let Implement = Self.project(.data(.Setting))
    }
    
    public struct FlowerSpot: TargetDependencyFactory {
      public static let Interface = Self.project(.data(.FlowerSpot, isInterface: true))
      public static let Implement = Self.project(.data(.FlowerSpot))
    }
    
    public struct Auth: TargetDependencyFactory {
      public static let Interface = Self.project(.data(.Auth, isInterface: true))
      public static let Implement = Self.project(.data(.Auth))
    }
    
    public struct User: TargetDependencyFactory {
      public static let Interface = Self.project(.data(.User, isInterface: true))
      public static let Implement = Self.project(.data(.User))
    }
    
    public struct Blooming: TargetDependencyFactory {
      public static let Interface = Self.project(.data(.Blooming, isInterface: true))
      public static let Implement = Self.project(.data(.Blooming))
    }
  }
  
  public struct SPM: TargetDependencyFactory {
    public static let TCA = Self.project(.spm(.TCA))
    public static let Dependencies = Self.project(.spm(.Dependencies))
    public static let NMap = Self.project(.spm(.NMap))
    public static let Lottie = Self.project(.spm(.Lottie))
    public static let DotLottie = Self.project(.spm(.DotLottie))
  }
  
  public struct Common: TargetDependencyFactory {
    public static let KeyChain = Self.project(.common(.KeyChain))
    public static let UserDefault = Self.project(.common(.UserDefault))
    public static let Utility = Self.project(.common(.Utility))
    public static let Networker = Self.project(.common(.Networker))
    public static let DesignKit = Self.project(.common(.DesignKit))
    public static let Cache = Self.project(.common(.Cache))
  }
  
  public static let NetworkKit = TargetDependency.project(
    target: "NetworkKit",
    path: .relativeToRoot("./Projects/NetworkKit")
  )
  
  // XCFramework 지원
  public struct XCFrameworks {
    /// XCFramework를 동적 이름으로 생성
    /// - Parameter name: XCFramework 이름
    /// - Returns: XCFramework TargetDependency
    public static func xcframework(named name: String) -> TargetDependency {
      .xcframework(path: .relativeToRoot("Frameworks/\(name).xcframework"))
    }
  }
}

//
//  MapUseCaseKey.swift
//  MapDomainInterface
//
//  Created by Jiyeon on 3/18/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Dependencies

/// UseCase DependencyKey 등록
///
/// 실제 구현부를 여기서 등록하지 않고, 외부에서 주입할 수 있도록 한다.
public enum MapUseCaseKey: DependencyKey {
  public static var liveValue: MapUseCase { mapUseCaseProvider() }
  public static var previewValue: MapUseCase { mapUseCaseProvider() }
  public static var testValue: MapUseCase { mapUseCaseProvider() }
}

/// 외부에서 주입한 provider를 연결
private var mapUseCaseProvider: () -> MapUseCase = {
    fatalError("MapUseCase dependency not configured")
}

/// 외부에서 의존성을 설정할 수 있는 함수
///
/// - 가장 상위에서 의존성을 한 번에 주입함
///
/// - 사용예시
/// ```swift
/// mapUseCaseRegister(
///   provider: { MapUseCaseImpl() }
/// }
/// ```
public func mapUseCaseRegister(
  provider: @escaping () -> MapUseCase
) {
  mapUseCaseProvider = provider
}

extension DependencyValues {
  public var mapUseCase: MapUseCase {
    get { self[MapUseCaseKey.self] }
    set { self[MapUseCaseKey.self] = newValue }
  }
}

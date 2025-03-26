////
////  MapUseCaseKey.swift
////  MapDomainInterface
////
////  Created by Jiyeon on 3/18/25.
////  Copyright © 2025 com.yongin.pida. All rights reserved.
////
//
//import Foundation
//import Dependencies
//
///// UseCase DependencyKey 등록
/////
///// 실제 구현부를 여기서 등록하지 않고, 외부에서 주입할 수 있도록 한다.
//public enum FetchFlowerUseCaseKey: DependencyKey {
//  public static var liveValue: FetchFlowerUseCase { fetchUseCaseProvider() }
//  public static var previewValue: FetchFlowerUseCase { fetchUseCaseProvider() }
//  public static var testValue: FetchFlowerUseCase { fetchUseCaseProvider() }
//}
//
///// 외부에서 주입한 provider를 연결
//var fetchUseCaseProvider: () -> FetchFlowerUseCase = {
//    fatalError("MapUseCase dependency not configured")
//}
//
///// 외부에서 의존성을 설정할 수 있는 함수
/////
///// - 가장 상위에서 의존성을 한 번에 주입함
/////
///// - 사용예시
///// ```swift
///// mapUseCaseRegister(
/////   provider: { MapUseCaseImpl() }
///// }
///// ```
//public func fetchFlowerUseCaseRegister(
//  provider: @escaping () -> FetchFlowerUseCase
//) {
//  fetchUseCaseProvider = provider
//}
//
//extension DependencyValues {
//  public var fetchFlowersUseCase: FetchFlowerUseCase {
//    get { self[FetchFlowerUseCaseKey.self] }
//    set { self[FetchFlowerUseCaseKey.self] = newValue }
//  }
//}

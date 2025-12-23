# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요
피다(PIDA)는 우리 동네 꽃길 안내 iOS 앱입니다. 사용자들이 주변 꽃 명소를 지도에서 찾고, 개화 상태를 제보하며, 검색 기능을 통해 원하는 꽃 장소를 발견할 수 있습니다.

## 빌드 시스템 및 필수 명령어

### Tuist 기반 빌드 시스템
프로젝트는 Tuist v4.43.2를 사용하여 Xcode 프로젝트를 생성하고 관리합니다.

```bash
# 프로젝트 생성 (필수: 코드 수정 후 반드시 실행)
tuist install && tuist generate

# 캐시 정리 및 재생성
tuist clean
tuist install && tuist generate

# 프로젝트 그래프 시각화
tuist graph

# 새 Feature 모듈 생성
tuist scaffold Feature --name FeatureName --author "AuthorName"

# 새 Client 모듈 생성
tuist scaffold Client --name ClientName --author "AuthorName"
```

### Scheme 및 빌드 타겟
- **Debug-PIDA scheme**: 개발 환경 (Debug.xcconfig, PIDA_DEV 타겟)
- **PROD-PIDA scheme**: 프로덕션 환경 (Release.xcconfig, pida 타겟)

### 테스트 실행
```bash
# 특정 모듈 테스트 실행 (Xcode에서)
# Scheme 선택: {ModuleName}Testing
# Cmd+U로 테스트 실행

# Demo 앱 실행 (개별 Feature 개발 시)
# Scheme 선택: {FeatureName}Demo
# Cmd+R로 실행
```

## 아키텍처 핵심 구조

### Native-TCA 아키텍처
> Clean Architecture 대신 TCA의 `@DependencyClient`를 활용한 단순화된 구조입니다.
> 자세한 마이그레이션 배경은 `ARCHITECTURE_MIGRATION.md`를 참고하세요.

### 모듈 구조
```
Projects/
├── Client/              # 도메인별 @DependencyClient 모듈
│   ├── API/             # 공통 HTTP 클라이언트
│   ├── Auth/            # 인증 (로그인/로그아웃)
│   ├── User/            # 사용자 정보
│   ├── FlowerSpot/      # 꽃 명소
│   ├── Blooming/        # 개화 상태
│   ├── Search/          # 검색
│   └── Cache/           # 캐시 (메모리 + 디스크)
├── Feature/             # TCA Reducer + SwiftUI View
│   ├── Auth/
│   ├── Map/
│   ├── Search/
│   ├── FlowerSpotDetail/
│   ├── Blooming/
│   └── Setting/
├── DesignKit/           # 디자인 시스템
├── Shared/              # 공용 유틸리티
├── ThirdParty/          # 외부 라이브러리 래퍼
└── PIDA/                # 메인 앱 타겟
```

### 레이어 흐름
```
Feature (UI/Reducer)
    ↓ @Dependency
Client (비즈니스 로직 + API 호출)
    ↓ @Dependency
APIClient (HTTP 통신)
```

## Client 모듈 패턴

### 파일 구조
```
Projects/Client/{Domain}/
├── Project.swift
└── Sources/
    ├── Client/
    │   ├── {Domain}Client.swift           # @DependencyClient 정의
    │   ├── {Domain}Client+Live.swift      # liveValue 구현
    │   └── {Domain}Client+Endpoint.swift  # API 엔드포인트
    ├── DTO/
    │   ├── Request/                       # 요청 바디
    │   └── Response/                      # 응답 DTO
    └── Entity/                            # 도메인 모델
```

### Client 정의 예시
```swift
// {Domain}Client.swift
import ComposableArchitecture

@DependencyClient
public struct AuthClient: Sendable {
  public var appleLogin: @Sendable (_ token: String) async throws -> SocialLoginEntity
  public var signUp: @Sendable (_ email: String, _ nickname: String) async throws -> SignUpEntity
  public var logout: @Sendable () async throws -> LogoutEntity
}

public extension DependencyValues {
  var authClient: AuthClient {
    get { self[AuthClient.self] }
    set { self[AuthClient.self] = newValue }
  }
}
```

### Live 구현 예시
```swift
// {Domain}Client+Live.swift
import Dependencies

extension AuthClient: DependencyKey {
  public static let liveValue: AuthClient = {
    @Dependency(\.apiClient) var apiClient

    return AuthClient(
      appleLogin: { token in
        let dto = try await apiClient.execute(AuthEndpoint.appleLogin(token: token))
        return dto.toEntity()
      },
      signUp: { email, nickname in
        let dto = try await apiClient.execute(AuthEndpoint.signUp(email: email, nickname: nickname))
        return dto.toEntity()
      },
      logout: {
        let dto = try await apiClient.execute(AuthEndpoint.logout)
        return dto.toEntity()
      }
    )
  }()
}
```

### Endpoint 정의 예시
```swift
// {Domain}Client+Endpoint.swift
import APIClient

enum AuthEndpoint: APIRequestable {
  case appleLogin(token: String)
  case signUp(email: String, nickname: String)
  case logout

  typealias Response = LoginDTO // 또는 각 케이스별 Response

  var path: String {
    switch self {
    case .appleLogin: return "/auth/apple"
    case .signUp: return "/auth/signup"
    case .logout: return "/auth/logout"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .appleLogin, .signUp: return .post
    case .logout: return .delete
    }
  }

  var body: Encodable? { ... }
}
```

## TCA (The Composable Architecture) 패턴

### Feature 구현 기본 구조
```swift
// Reducer 정의 (Interface)
@Reducer
public struct FeatureNameReducer {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case viewDidAppear
    case delegate(Delegate)
  }

  public enum Delegate: Equatable {
    case didComplete
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

// View 정의
public struct FeatureNameView: View {
  @Bindable var store: StoreOf<FeatureNameReducer>

  public var body: some View {
    // SwiftUI View
  }
}
```

### Reducer에서 Client 사용
```swift
@Reducer
public struct AuthReducer {
  @Dependency(\.authClient) var authClient

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loginButtonTapped:
        return .run { send in
          do {
            let result = try await authClient.appleLogin(token)
            await send(.inner(.loginSuccess(result)))
          } catch {
            await send(.inner(.loginFailure(error)))
          }
        }
      // ...
      }
    }
  }
}
```

### Reducer 분리 패턴 (서브 기능)
```swift
@Reducer
public struct MapReducer {
  private let reducer: Reduce<State, Action>
  private let location: Reduce<State, LocationAction>
  private let detail: Reduce<State, DetailAction>

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.self, action: \.location) {
      location
    }
    Scope(state: \.self, action: \.detail) {
      detail
    }
    reducer
  }
}
```

## Feature 모듈 구조

각 Feature는 독립적으로 개발/테스트 가능:
- `{Feature}Feature`: TCA Reducer 구현체
- `{Feature}FeatureInterface`: TCA Reducer 인터페이스, SwiftUI View
- `{Feature}FeatureTesting`: 단위 테스트
- `{Feature}Demo`: 독립 실행 가능한 Demo 앱

### 주요 Feature
- **Map**: 네이버 지도 기반 꽃 장소 표시
- **Search**: 꽃 장소 검색
- **FlowerSpotDetail**: 장소 상세 정보
- **Blooming**: 개화 상태 제보
- **Auth**: 애플 로그인 인증
- **Setting**: 사용자 설정

## 개발 워크플로우

### 새 Client 추가 시
1. `tuist scaffold Client --name {Name}` 실행
2. `{Name}Client.swift`에 필요한 메서드 정의
3. `{Name}Client+Live.swift`에서 liveValue 구현
4. `{Name}Client+Endpoint.swift`에서 API 정의
5. DTO/Entity 모델 추가
6. `tuist generate` 실행

### 새 Feature 추가 시
1. `tuist scaffold Feature --name {Name}` 실행
2. Interface에 Reducer State/Action/Delegate 정의
3. Interface에 View 구현
4. Implement에 Reducer 로직 구현
5. 부모 Feature에 Scope로 연결
6. `tuist generate` 실행

### 코드 수정 후
```bash
# 프로젝트 재생성 필수
tuist generate

# Xcode에서 빌드
# Debug-PIDA scheme 선택 후 Cmd+B
```

## 주요 설정 파일 위치
- 환경 변수: `Config/Debug.xcconfig`, `Config/Release.xcconfig`
- Naver Maps API 키: Info.plist의 `NMCLIENTID`
- Base URL: Info.plist의 `BASE_URL`
- Entitlements: `Config/Debug.entitlements`, `Config/Release.entitlements`
- CI 스크립트: `ci_scripts/ci_post_clone.sh`
- Fastlane Match: `fastlane/Matchfile`

## 자주 사용하는 패턴

### Alert 표시
```swift
@ObservableState
public struct State: Equatable {
  public var alertType: AlertType? = nil
}

public enum Action {
  case presentAlert(type: AlertType)
  case alertCancelTapped
  case alertAcceptTapped(AlertType)
  case clearAlertState
}
```

### Toast 표시
```swift
case showToastView(message: String?, buttonLabel: String?)
case toastActionTapped

state.toastMessage = message
state.toastLabel = buttonLabel
```

### 비동기 작업 처리
```swift
return .run { send in
  do {
    let result = try await client.fetchData()
    await send(.inner(.fetchSuccess(result)))
  } catch {
    await send(.inner(.fetchFailure(error)))
  }
}
```

### Delegate 패턴 (부모-자식 통신)
```swift
public enum Delegate: Equatable {
  case didComplete
  case presentToDetail(data: SomeData)
}

// 부모에서 처리
case .child(.delegate(.didComplete)):
  // 처리 로직
```

### Cache 사용
```swift
@Dependency(\.cache) var cache

// 저장
try await cache.set(.userProfile, userProfile)

// 조회
let profile: UserProfile? = await cache.get(.userProfile)

// 삭제
await cache.remove(.userProfile)
```

## 디버깅 팁
- Demo 앱으로 개별 Feature 독립 실행 가능
- 각 모듈별 Testing 타겟으로 단위 테스트
- Tuist graph로 의존성 시각화
- 환경별 설정은 xcconfig 파일 확인
- `@DependencyClient`는 testValue/previewValue 자동 생성

## 코드 스타일
- 들여쓰기: 2 spaces
- 지역: 한국어 (`ko`)
- 최소 배포 타겟: iOS 18.0

## Tuist 프로젝트 설정

### ProjectDescriptionHelpers 구조
```
Tuist/ProjectDescriptionHelpers/
├── ProjectBuilders/           # 프로젝트 빌더
│   ├── BaseProjectBuilder.swift
│   ├── AppProjectBuilder.swift
│   ├── FeatureProjectBuilder.swift
│   └── FrameworkProjectBuilder.swift
├── TargetBuilders/            # 타겟 빌더
│   ├── BaseTargetBuilder.swift
│   ├── AppTargetBuilder.swift
│   └── FrameworkTargetBuilder.swift
├── TargetDependency/          # 의존성 정의
│   ├── Modules.swift          # 모듈 열거형
│   ├── DependencyComponent.swift
│   └── TargetDependencyBuilder.swift
├── Scheme+.swift
└── Settings+.swift
```

## 외부 의존성 추가 방법
1. `Tuist/Package.swift`에 패키지 추가
2. `Tuist/ProjectDescriptionHelpers/TargetDependency/DependencyComponent.swift`에 등록
3. 해당 모듈의 `Project.swift`에서 의존성 추가

## CI/CD

### Xcode Cloud
- `ci_scripts/ci_post_clone.sh`가 빌드 전 자동 실행
- mise로 Tuist 설치 후 프로젝트 생성

### Fastlane Match
- 인증서/프로비저닝 프로파일 Git 저장소 관리
- `fastlane/Matchfile` 설정 참고

## Git 규칙
- 커밋 형식: `타입: #이슈번호 설명`
- 타입: `fix`, `feat`, `chore`, `docs`, `refactor`, `delete`
- PR 대상 브랜치: `release`

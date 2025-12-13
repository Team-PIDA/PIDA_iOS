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

# 새 Domain 모듈 생성
tuist scaffold Domain --name DomainName --author "AuthorName"

# 새 Data 모듈 생성
tuist scaffold Data --name DataName --author "AuthorName"
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

### 레이어 구조 (하위 레이어는 상위 레이어를 알 수 없음)
```
Feature (UI) → Domain (Business Logic) → Data (API/Repository)
     ↓              ↓                        ↓
   Shared    ←    Core    ←              Networker
```

### TCA (The Composable Architecture) 패턴

#### 1. Feature 구현 기본 구조
```swift
// Reducer 정의 (Interface)
@Reducer
public struct FeatureNameReducer {
  private let reducer: Reduce<State, Action>

  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  // State: ObservableState 사용
  @ObservableState
  public struct State: Equatable {
    // 상태 정의
    public init() {}
  }

  // Action 정의
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case viewDidAppear
    case delegate(Delegate)
  }

  // Delegate (부모-자식 통신)
  public enum Delegate: Equatable {
    case didComplete
  }

  // Reducer body
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

#### 2. Reducer 분리 패턴 (Location/Detail 등 서브 기능)
```swift
// MapReducer 예시 - 서브 Reducer를 조합
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

### Domain Layer (UseCase 패턴)

#### 1. UseCase Interface 정의
```swift
// DomainInterface/Sources/UseCases/SomeUseCase.swift
public protocol SomeUseCase {
  func execute(param: String) async throws -> Result
}
```

#### 2. DependencyKey 정의
```swift
// DomainInterface/Sources/DependencyKeys/SomeUseCaseKey.swift
public enum SomeUseCaseKey: DependencyKey {
  public static var liveValue: SomeUseCase { someUseCaseProvider() }
  public static var previewValue: SomeUseCase { someUseCaseProvider() }
  public static var testValue: SomeUseCase { someUseCaseProvider() }
}

var someUseCaseProvider: () -> SomeUseCase = {
  fatalError("SomeUseCase Dependency not configured")
}

public func someUseCaseRegister(provider: @escaping () -> SomeUseCase) {
  someUseCaseProvider = provider
}

extension DependencyValues {
  public var someUseCase: SomeUseCase {
    get { self[SomeUseCaseKey.self] }
    set { self[SomeUseCaseKey.self] = newValue }
  }
}
```

#### 3. UseCase 구현
```swift
// Domain/Sources/SomeUseCaseImpl.swift
public struct SomeUseCaseImpl: SomeUseCase {
  private let repository: SomeRepository

  public init(repository: SomeRepository) {
    self.repository = repository
  }

  public func execute(param: String) async throws -> Result {
    return try await repository.fetch(param: param)
  }
}
```

### Data Layer (Repository 패턴)

```swift
// Repository 구현
public struct SomeRepositoryImpl: SomeRepository {
  private let networker: NetworkProtocol

  public func fetch(param: String) async throws -> Result {
    let dto = try await networker.request(SomeAPI.fetch(param: param))
    return dto.toDomain()
  }
}

// API 정의
enum SomeAPI: APIRequestable {
  case fetch(param: String)

  var path: String { "/api/endpoint" }
  var method: HTTPMethod { .get }
}
```

### Dependency Injection

```swift
// Projects/PIDA/Sources/DependencyRegister.swift
enum DependencyRegistry {
  static func registerDependencies() {
    let networker = Networker()
    let someRepository = SomeRepositoryImpl(networker: networker)

    // UseCase 등록
    someUseCaseRegister {
      SomeUseCaseImpl(repository: someRepository)
    }
  }
}
```

## 모듈 구조 및 역할

### Core 모듈
- **Networker**: HTTP 네트워킹 추상화, 토큰 리프레시
- **DesignKit**: 디자인 시스템, SwiftUI 컴포넌트, 색상/폰트
- **Cache**: 2단계 캐싱 (메모리 + 디스크)

### Shared 모듈
- **Utility**: Extensions, Common Types
- **KeyChain**: 토큰 저장
- **UserDefault**: 사용자 설정
- **ThirdParty**: 외부 라이브러리 래퍼

### Feature 모듈
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

### Feature 추가 시
1. Tuist scaffold로 모듈 생성
2. DomainInterface에 UseCase protocol 정의
3. DomainInterface에 DependencyKey 정의
4. Domain에 UseCase 구현
5. DataInterface에 Repository protocol 정의
6. Data에 Repository 구현
7. Feature에 TCA Reducer/View 구현
8. DependencyRegister에 의존성 등록
9. 부모 Feature에 Scope로 연결

### 코드 수정 후
```bash
# 프로젝트 재생성 필수
tuist generate

# Xcode에서 빌드
# Debug-PIDA scheme 선택 후 Cmd+B
```

### PR 작성 시
- release 브랜치로 PR 생성

## 주요 설정 파일 위치
- 환경 변수: `Config/Debug.xcconfig`, `Config/Release.xcconfig`
- Naver Maps API 키: Info.plist의 `NMCLIENTID`
- Base URL: Info.plist의 `BASE_URL`
- Entitlements: `Config/Debug.entitlements`, `Config/Release.entitlements`

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
    let result = try await useCase.execute()
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

## 디버깅 팁
- Demo 앱으로 개별 Feature 독립 실행 가능
- 각 모듈별 Testing 타겟으로 단위 테스트
- Tuist graph로 의존성 시각화
- 환경별 설정은 xcconfig 파일 확인

## 코드 스타일
- 들여쓰기: 2 spaces
- 지역: 한국어 (`ko`)
- 최소 배포 타겟: iOS 18.0

## 외부 의존성 추가 방법
1. `Tuist/Package.swift`에 패키지 추가
2. `Tuist/ProjectDescriptionHelpers/TargetDependency+.swift`에 등록
3. `.ThirdParty.{Name}` 또는 `.CoreTarget.{Name}` 등으로 참조

## Git 커밋 규칙
- 커밋 메시지에 Co-Authored-By 또는 Claude 관련 정보를 포함하지 않음
- 커밋 형식: `타입: #이슈번호 설명`
- 타입 예시: `fix`, `feat`, `chore`, `docs`, `refactor`

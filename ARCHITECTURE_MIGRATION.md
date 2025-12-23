# PIDA iOS 아키텍처 마이그레이션 가이드

> 이 문서는 Clean Architecture에서 Native-TCA 구조로의 마이그레이션 과정과 주요 변경사항을 설명합니다.

## 목차
- [마이그레이션 배경](#마이그레이션-배경)
- [주요 변경사항](#주요-변경사항)
- [아키텍처 비교](#아키텍처-비교)
- [Client 모듈 패턴](#client-모듈-패턴)
- [Tuist 프로젝트 설정](#tuist-프로젝트-설정)
- [CI/CD 구성](#cicd-구성)

---

## 마이그레이션 배경

### Clean Architecture + TCA의 문제점

기존 구조에서는 Clean Architecture(Domain/Data 레이어)와 TCA를 함께 사용했습니다.
하지만 이 조합에서 다음과 같은 설계상 충돌이 발생했습니다:

#### 1. 의존성 역전 원칙(DIP) 위반 불가피

```
[기존 구조의 딜레마]

Domain Layer (비즈니스 로직, 순수해야 함)
    └── UseCase Protocol
    └── DependencyKey ← TCA 프레임워크 의존 필요!
         ↑
         문제: 순수해야 할 Domain이 외부 프레임워크(TCA)를 의존
```

- **UseCase를 `@Dependency`로 주입하려면** → Domain이 TCA를 import해야 함
- **Domain이 외부 프레임워크를 의존하면** → Clean Architecture의 핵심 원칙 위반
- **TCA 없이 DependencyKey를 구현하면** → 별도의 DI 컨테이너 필요 (복잡성 증가)

#### 2. 과도한 보일러플레이트

```swift
// 기존: 하나의 API 호출을 위해 필요했던 파일들
├── DomainInterface/
│   ├── UseCases/GetUserUseCase.swift       // Protocol
│   └── DependencyKeys/GetUserUseCaseKey.swift
├── Domain/
│   └── GetUserUseCaseImpl.swift            // Implementation
├── DataInterface/
│   └── UserRepository.swift                // Protocol
├── Data/
│   ├── UserRepositoryImpl.swift            // Implementation
│   └── UserAPI.swift                       // Endpoint
└── Feature/
    └── UserReducer.swift                   // 실제 사용처

// 총 7개 파일, 4개 모듈
```

#### 3. 레이어 간 매핑 오버헤드

```swift
// DTO → Entity → Domain Model 변환의 반복
struct UserDTO: Decodable { ... }
struct UserEntity { ... }  // 대부분 DTO와 동일
func toDomain() -> UserEntity { ... }  // 단순 매핑 코드
```

### Native-TCA 구조의 장점

TCA의 `@DependencyClient`는 이미 충분히 강력한 의존성 관리를 제공합니다:

- **자동 Mock 생성**: `testValue`, `previewValue` 자동 제공
- **컴파일 타임 안전성**: 누락된 의존성 즉시 감지
- **단순한 구조**: Protocol 없이 struct만으로 인터페이스 정의

---

## 주요 변경사항

### 1. 모듈 구조 변경

```
[Before: Clean Architecture]
Projects/
├── Core/
│   ├── Networker/          # HTTP 클라이언트
│   └── Cache/              # 캐시 시스템
├── Domain/
│   ├── Auth/
│   │   ├── Interface/      # UseCase Protocol, DependencyKey
│   │   └── Implement/      # UseCase 구현
│   └── ...
├── Data/
│   ├── Auth/
│   │   ├── Interface/      # Repository Protocol
│   │   └── Implement/      # Repository 구현, DTO, API
│   └── ...
├── Feature/
│   └── Auth/
│       ├── Interface/      # Reducer Interface, View
│       └── Implement/      # Reducer 구현
└── Shared/

[After: Native-TCA]
Projects/
├── Client/                 # 도메인별 통합 클라이언트
│   ├── API/                # 공통 네트워크 클라이언트
│   ├── Auth/               # 인증 클라이언트
│   ├── User/               # 사용자 클라이언트
│   ├── FlowerSpot/         # 꽃 명소 클라이언트
│   ├── Blooming/           # 개화 상태 클라이언트
│   ├── Search/             # 검색 클라이언트
│   └── Cache/              # 캐시 클라이언트
├── Feature/                # TCA Reducer + View
│   └── Auth/
│       ├── Interface/
│       └── Implement/
├── DesignKit/              # 디자인 시스템
├── Shared/                 # 공용 유틸리티
└── ThirdParty/             # 외부 라이브러리 래퍼
```

### 2. 삭제된 레이어

| 삭제된 모듈 | 이유 |
|------------|------|
| `Domain/Interface` | UseCase Protocol → Client struct로 대체 |
| `Domain/Implement` | UseCase 구현 → Client+Live로 통합 |
| `Data/Interface` | Repository Protocol → 불필요 (Client가 직접 API 호출) |
| `Data/Implement` | Repository 구현 → Client+Live로 통합 |
| `Core/Networker` | 별도 모듈 → APIClient로 통합 |
| `AppDependency` | DI 등록 모듈 → @DependencyClient 자동 처리 |

### 3. 파일 수 변화

```
Before: 단일 도메인 (Auth) 구현에 필요한 파일
- UseCase Protocol, DependencyKey, UseCase Impl
- Repository Protocol, Repository Impl, DTO, API
- Reducer Interface, View, Reducer Impl
= 약 10-12개 파일

After: 단일 도메인 (Auth) 구현에 필요한 파일
- AuthClient.swift (인터페이스)
- AuthClient+Live.swift (구현)
- AuthClient+Endpoint.swift (API 정의)
- DTO/, Entity/ (데이터 모델)
- Reducer Interface, View, Reducer Impl
= 약 6-8개 파일

약 40% 파일 수 감소
```

---

## 아키텍처 비교

### Before: Clean Architecture 흐름

```
┌─────────────────────────────────────────────────────────────────┐
│                         Feature Layer                           │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │    Reducer      │───▶│    UseCase      │ (via @Dependency)  │
│  │  (Interface)    │    │   (Protocol)    │                    │
│  └─────────────────┘    └────────┬────────┘                    │
└──────────────────────────────────┼──────────────────────────────┘
                                   │
┌──────────────────────────────────┼──────────────────────────────┐
│                         Domain Layer                            │
│                    ┌─────────────▼────────────┐                 │
│                    │    UseCaseImpl           │                 │
│                    │  (Implementation)        │                 │
│                    └─────────────┬────────────┘                 │
│                                  │                              │
│                    ┌─────────────▼────────────┐                 │
│                    │    Repository            │                 │
│                    │    (Protocol)            │                 │
│                    └─────────────┬────────────┘                 │
└──────────────────────────────────┼──────────────────────────────┘
                                   │
┌──────────────────────────────────┼──────────────────────────────┐
│                          Data Layer                             │
│                    ┌─────────────▼────────────┐                 │
│                    │   RepositoryImpl         │                 │
│                    │  (Implementation)        │                 │
│                    └─────────────┬────────────┘                 │
│                                  │                              │
│                    ┌─────────────▼────────────┐                 │
│                    │      Networker           │                 │
│                    │   (HTTP Client)          │                 │
│                    └──────────────────────────┘                 │
└─────────────────────────────────────────────────────────────────┘
```

### After: Native-TCA 흐름

```
┌─────────────────────────────────────────────────────────────────┐
│                         Feature Layer                           │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │    Reducer      │───▶│  DomainClient   │ (via @Dependency)  │
│  │  (Interface)    │    │    (struct)     │                    │
│  └─────────────────┘    └────────┬────────┘                    │
└──────────────────────────────────┼──────────────────────────────┘
                                   │
┌──────────────────────────────────┼──────────────────────────────┐
│                         Client Layer                            │
│                    ┌─────────────▼────────────┐                 │
│                    │   DomainClient+Live      │                 │
│                    │   (liveValue 구현)        │                 │
│                    └─────────────┬────────────┘                 │
│                                  │                              │
│                    ┌─────────────▼────────────┐                 │
│                    │      APIClient           │                 │
│                    │   (@DependencyClient)    │                 │
│                    └──────────────────────────┘                 │
└─────────────────────────────────────────────────────────────────┘

레이어 수: 3 → 2 (Domain + Data → Client로 통합)
```

---

## Client 모듈 패턴

### 파일 구조

```
Projects/Client/{Domain}/
├── Project.swift
└── Sources/
    ├── Client/
    │   ├── {Domain}Client.swift           # @DependencyClient 정의
    │   ├── {Domain}Client+Live.swift      # liveValue 구현
    │   └── {Domain}Client+Endpoint.swift  # API 엔드포인트 정의
    ├── DTO/
    │   ├── Request/                       # 요청 바디
    │   └── Response/                      # 응답 DTO
    └── Entity/                            # 도메인 모델
```

### 코드 예시

#### 1. Client 정의 (`AuthClient.swift`)

```swift
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

#### 2. Live 구현 (`AuthClient+Live.swift`)

```swift
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

#### 3. Endpoint 정의 (`AuthClient+Endpoint.swift`)

```swift
import APIClient

enum AuthEndpoint: APIRequestable {
  case appleLogin(token: String)
  case signUp(email: String, nickname: String)
  case logout

  typealias Response = // DTO 타입

  var path: String { ... }
  var method: HTTPMethod { ... }
  var body: Encodable? { ... }
}
```

#### 4. Feature에서 사용

```swift
@Reducer
public struct AuthReducer {
  @Dependency(\.authClient) var authClient

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loginButtonTapped:
        return .run { send in
          let result = try await authClient.appleLogin(token)
          await send(.loginResponse(result))
        }
      }
    }
  }
}
```

---

## Tuist 프로젝트 설정

### Builder 패턴 도입

기존의 단일 `Target+.swift` 파일을 역할별 Builder로 분리했습니다:

```
Tuist/ProjectDescriptionHelpers/
├── ProjectBuilders/
│   ├── BaseProjectBuilder.swift
│   ├── AppProjectBuilder.swift
│   ├── FeatureProjectBuilder.swift
│   ├── FrameworkProjectBuilder.swift
│   └── StaticLibraryProjectBuilder.swift
├── TargetBuilders/
│   ├── BaseTargetBuilder.swift
│   ├── AppTargetBuilder.swift
│   ├── FrameworkTargetBuilder.swift
│   └── DemoTargetBuilder.swift
├── TargetDependency/
│   ├── Modules.swift              # 모듈 열거형
│   ├── DependencyComponent.swift  # 의존성 그룹
│   └── TargetDependencyBuilder.swift
├── Scheme+.swift
└── Settings+.swift
```

### Client 모듈 생성 템플릿

```bash
# 새로운 Client 모듈 생성
tuist scaffold Client --name User --author "AuthorName"

# 생성되는 파일:
# Projects/Client/User/
# ├── Project.swift
# └── Sources/
#     └── Client/
#         ├── UserClient.swift
#         ├── UserClient+Live.swift
#         └── UserClient+Endpoint.swift
```

---

## CI/CD 구성

### Xcode Cloud 설정

`ci_scripts/ci_post_clone.sh` 스크립트가 자동으로:

1. **mise 설치**: 버전 관리 도구
2. **Tuist 설치**: `.mise.toml`에서 버전 읽어옴
3. **의존성 설치**: `tuist install`
4. **프로젝트 생성**: `tuist generate --no-open`

```bash
#!/bin/sh
# ci_scripts/ci_post_clone.sh

curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

mise install
tuist clean
tuist install
tuist generate --no-open
```

### Fastlane Match 설정

코드 서명 인증서/프로비저닝 프로파일을 Git 저장소로 관리:

```ruby
# fastlane/Matchfile
git_url("https://github.com/team/certificates.git")
storage_mode("git")
app_identifier(["com.pida.me.ios", "com.pida.me.ios-dev"])
type("development", "appstore")
```

---

## 마이그레이션 체크리스트

### 기존 코드 마이그레이션 시

- [ ] Domain/Interface의 UseCase Protocol → Client struct로 변환
- [ ] Domain/Implement의 UseCase 구현 → Client+Live로 이동
- [ ] Data/Interface의 Repository Protocol → 삭제 (불필요)
- [ ] Data/Implement의 Repository 구현 → Client+Live로 통합
- [ ] DependencyRegister 호출 코드 → 삭제 (@DependencyClient가 자동 처리)
- [ ] Feature의 UseCase 의존성 → Client 의존성으로 변경

### 새 기능 개발 시

1. `tuist scaffold Client --name {Name}` 실행
2. Client struct에 필요한 메서드 정의
3. Client+Live에서 liveValue 구현
4. Client+Endpoint에서 API 정의
5. DTO/Entity 모델 추가
6. Feature에서 `@Dependency(\.{name}Client)` 사용

---

## 참고 자료

- [TCA Documentation - Dependencies](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/dependencymanagement)
- [Point-Free: Designing Dependencies](https://www.pointfree.co/collections/dependencies)
- [Tuist Documentation](https://docs.tuist.io/)

//
//  CategoryFeature.swift
//  MapFeature
//
//  Created by Jiyeon
//

import ComposableArchitecture
import MapFeatureInterface
import Shared

extension CategoryFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.categoryClient) var categoryClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .fetchCategoryList:
        return fetchCategoryList()
        
      case let .storeCategoryList(item):
        guard !item.isEmpty else { return .none }
        state.categoryList = [.init(id: -1, category: "전체")] + item
        return .none

      case let .tapCategory(id):
        state.selectedCategoryId = id
        if id == -1 {
          return .send(.delegate(.resetCategory))
        }
        let title = state.categoryList.first(where: { $0.id == id })?.category ?? ""
        return .send(.delegate(.tapCategory(title: title)))

      case .resetToAll:
        state.selectedCategoryId = -1
        state.categoryListDetent = .medium
        return .none

      case .changeCategorySheetDetent:
        if state.isShowCategoryList {
          state.categoryListDetent = .low
        }
        return .none

      case let .fetchFlowerSpots(title):
        return fetchFlowerSpots(title: title)

      case .delegate:
        return .none
      }
    }
  }
}

extension CategoryFeature.Core {
  
  private func fetchCategoryList() -> Effect<Action> {
    return .run { send in
      do {
        let categoryItem = try await categoryClient.fetchCategories()
        await send(.storeCategoryList(categoryItem))
      } catch {
        
      }
    }
  }
  
  // TODO: 임시 데이터 - 서버 데이터 확정 후 실제 API 연동으로 교체 필요
  private func fetchFlowerSpots(title: String) -> Effect<Action> {
    return .send(.delegate(.didFetchFlowerSpots([
      .init(
        id: 1,
        address: "서울특별시 영등포구 여의도동 1",
        recentlyVisitedCount: 238,
        bloomingStatus: "BLOOMED",
        streetName: "여의도 벚꽃길",
        district: "여의도동",
        description: "왕벚나무",
        path: [],
        pinPoint: .init(latitude: 37.5282, longitude: 126.9329),
        region: "서울"
      ),
      .init(
        id: 2,
        address: "서울특별시 마포구 상암동 133",
        recentlyVisitedCount: 45,
        bloomingStatus: "LITTLE",
        streetName: "상암 하늘공원 벚꽃길",
        district: "상암동",
        description: "왕벚나무",
        path: [],
        pinPoint: .init(latitude: 37.5718, longitude: 126.8986),
        region: "서울"
      ),
      .init(
        id: 3,
        address: "서울특별시 성동구 성수동1가 685",
        recentlyVisitedCount: 12,
        bloomingStatus: "NOT_BLOOMED",
        streetName: "서울숲 벚꽃길",
        district: "성수동",
        description: "산벚나무",
        path: [],
        pinPoint: .init(latitude: 37.5441, longitude: 127.0374),
        region: "서울"
      ),
      .init(
        id: 4,
        address: "서울특별시 종로구 와룡동 2-1",
        recentlyVisitedCount: 321,
        bloomingStatus: "WITHERED",
        streetName: "창덕궁 벚꽃길",
        district: "와룡동",
        description: "왕벚나무",
        path: [],
        pinPoint: .init(latitude: 37.5794, longitude: 126.9910),
        region: "서울"
      )
    ])))
  }
}

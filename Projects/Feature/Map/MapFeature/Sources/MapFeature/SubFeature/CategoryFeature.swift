//
//  CategoryFeature.swift
//  MapFeature
//
//  Created by Jiyeon
//

import ComposableArchitecture
import MapFeatureInterface
import CategoryClient
import Shared
import DesignKit

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
        state.categoryList = [.init(id: 0, title: "전체", label: "ALL")] + item
        return .none

      case let .tapCategory(item):
        state.selectedCategory = item.type
        if item.type == .all {
          return .send(.delegate(.resetCategory))
        }
        return .concatenate(
          .send(.delegate(.tapCategory(item))),
          .send(.delegate(.requestMapBounds))
        )

      case .resetToAll:
        state.selectedCategory = .all
        state.categoryListDetent = .medium
        return .send(.delegate(.resetCategory))

      case .changeCategorySheetDetent:
        if state.isShowCategoryList {
          state.categoryListDetent = .low
        }
        return .none
        
      case let .fetchCategorySpots(coordinates):
        return fetchFlowerSpots(type: state.selectedCategory.spotType)

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
  private func fetchFlowerSpots(type: MapSpotType) -> Effect<Action> {
    return .send(
      .delegate(
        .didFetchFlowerSpots(
          [.init(
            id: 1,
            address: "서울특별시 영등포구 여의도동 1",
            recentlyVisitedCount: 0,
            bloomingStatus: "BLOOMED",
            streetName: "여의도 벚꽃길",
            district: "여의도동",
            description: "왕벚나무",
            path: [],
            pinPoint: .init(latitude: 37.5298, longitude: 126.9340),
            region: "서울"
          )],
          type: type
        )
      )
    )
  }
}

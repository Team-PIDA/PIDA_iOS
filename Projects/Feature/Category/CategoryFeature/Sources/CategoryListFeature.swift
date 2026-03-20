//
//  CategoryFeature.swift
//  CategoryFeature
//
//  Created by Jiyeon on 3/4/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import CategoryFeatureInterface
import CategoryClient

extension CategoryListFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case let .tapFilter(item):
        state.selectedFilter = item.code
        return .send(.delegate(.refetchItemsWithRegion(item)))

      case let .storeCategoryItems(categoryItemList):
        state.categoryId = categoryItemList.categoryId
        state.categoryType = categoryItemList.categoryType
        state.categoryItems = categoryItemList.list
        state.headerTitle = categoryItemList.title
        state.isLoading = false
        state.isDataEmpty = categoryItemList.list.isEmpty
        
        if categoryItemList.list.isEmpty,
           let toast = categoryItemList.categoryType.emptyToast {
          return .send(.delegate(.showEmptyToast(message: toast.message, buttonLabel: toast.buttonLabel)))
        }
        return .none

      case let .spotTapped(spotId):
        return .send(.delegate(.showCategoryDetail(spotId: spotId)))

      case .delegate:
        return .none
      }
    }
  }
}

//extension CategoryEntity {
//  func title(count: Int) -> String {
//    switch self.type {
//    case .event: return "2026 벚꽃 축제 \(count)곳"
//    case .trail: return "주변에 걷기 좋은 산책로 \(count)곳이 있어요"
//    case .cafe: return "주변에 벚꽃 뷰 카페 \(count)곳을 찾았어요"
//    default: return ""
//    }
//  }
//}

extension CategoryType {
  var emptyToast: (message: String, buttonLabel: String?)? {
    switch self {
    case .cafe: return ("이 근방에는 카페가 없어요.", nil)
    case .trail: return ("이 근방에는 꽃길이 없어요.", "제보하기")
    default: return nil
    }
  }
}

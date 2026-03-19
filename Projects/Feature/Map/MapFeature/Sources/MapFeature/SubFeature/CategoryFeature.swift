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
        state.selectedCategoryId = item.id
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
        guard let categoryId = state.selectedCategoryId else { return .none }
        return fetchCategoryItems(
          categoryId: categoryId,
          coordinates: coordinates
        )
        
      case let .errorLog(description):
        Logger.log(description, level: .error)
        return .none 

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
      } catch let error as NetworkError {
        await send(.errorLog(error.localizedDescription))
      } catch let error as FoundationError {
        await send(.errorLog(error.localizedDescription))
      } catch {
        await send(.errorLog(error.localizedDescription))
      }
    }
  }

  private func fetchCategoryItems(categoryId: Int, coordinates: [Coordinate]) -> Effect<Action> {
    let query = GetCategoryItemsQuery(
      swLat: coordinates[0].latitude,
      swLng: coordinates[0].longitude,
      neLat: coordinates[1].latitude,
      neLng: coordinates[1].longitude
    )
    return .run { send in
      do {
        let result = try await categoryClient.fetchCategoryItems(categoryId, query)
        await send(.delegate(.didFetchCategoryItems(result)))
      } catch let error as NetworkError {
        await send(.errorLog(error.localizedDescription))
      } catch let error as FoundationError {
        await send(.errorLog(error.localizedDescription))
      } catch {
        await send(.errorLog(error.localizedDescription))
      }
    }
  }
}

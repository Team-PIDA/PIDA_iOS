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
        guard item.type != state.selectedCategory else { return .none }
        state.selectedCategory = item.type
        
        switch item.type {
        case .all:
          state.selectedCategoryId = nil
          return .send(.delegate(.resetCategory))
        case .event:
          state.selectedCategoryId = item.id
          return .concatenate(
            .send(.delegate(.tapCategory(item))),
            fetchCategoryItems(categoryId: item.id)
          )
        default:
          state.selectedCategoryId = item.id
          return .concatenate(
            .send(.delegate(.tapCategory(item))),
            .send(.delegate(.requestMapBounds))
          )
        }
        
      case .resetToAll:
        state.selectedCategory = .all
        state.selectedCategoryId = nil
        state.categoryListDetent = .medium
        return .send(.delegate(.resetCategory))

      case .changeCategorySheetDetent:
        if state.isShowCategoryList {
          state.categoryListDetent = .low
        }
        return .none
        
      case let .fetchCategorySpots(sw, ne):
        guard let categoryId = state.selectedCategoryId else { return .none }
        return fetchCategoryItems(
          categoryId: categoryId,
          sw: sw,
          ne: ne
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

  private func fetchCategoryItems(
    categoryId: Int,
    sw: Coordinate? = nil,
    ne: Coordinate? = nil
  ) -> Effect<Action> {
    let query: GetCategoryItemsQuery = .init(
      swLat: sw?.latitude,
      swLng: sw?.longitude,
      neLat: ne?.latitude,
      neLng: ne?.longitude
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
    .cancellable(id: CategoryFeature.CancelID.fetchCategoryItems, cancelInFlight: true)
  }
}

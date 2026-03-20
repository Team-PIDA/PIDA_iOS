//
//  CategoryFeature.swift
//  MapFeature
//
//  Created by Jiyeon
//

import ComposableArchitecture
import MapFeatureInterface
import LocationClient
import CategoryClient
import Shared
import DesignKit

extension CategoryFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.categoryClient) var categoryClient
    @Dependency(\.locationClient) var locationClient
    
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
          return fetchRegionList(item: item)
        default:
          state.selectedCategoryId = item.id
          return .concatenate(
            .send(.delegate(.tapCategory(item, [], initialFilter: nil))),
            .send(.delegate(.requestMapBounds))
          )
        }

      case let .storeRegionList(regions, item, userRegion):
        let effectiveRegion: Region?
        if let userRegion, regions.compactMap(\.code).contains(userRegion) {
          effectiveRegion = userRegion
        } else {
          effectiveRegion = nil
        }
        return .concatenate(
          .send(.delegate(.tapCategory(item, regions, initialFilter: effectiveRegion))),
          fetchCategoryItems(categoryId: item.id, region: effectiveRegion?.rawValue)
        )
        
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

      case let .fetchEventCategoryItems(region):
        guard let categoryId = state.selectedCategoryId else { return .none }
        return fetchCategoryItems(categoryId: categoryId, region: region?.rawValue)
        
      case let .changeBottomSheetDetent(detent):
        state.categoryListDetent = detent
        return .none
        
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

  private func fetchRegionList(item: CategoryEntity) -> Effect<Action> {
    return .run { send in
      do {
        async let regions = categoryClient.fetchRegionList()
        async let userRegion = locationClient.requestUserRegion()
        let (fetchedRegions, fetchedUserRegion) = try await (regions, userRegion)
        await send(.storeRegionList(fetchedRegions, item, fetchedUserRegion))
      } catch let error as NetworkError {
        await send(.errorLog(error.localizedDescription))
      } catch let error as FoundationError {
        await send(.errorLog(error.localizedDescription))
      } catch {
        await send(.errorLog(error.localizedDescription))
      }
    }
  }

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
    ne: Coordinate? = nil,
    region: String? = nil
  ) -> Effect<Action> {
    let query: GetCategoryItemsQuery = .init(
      swLat: sw?.latitude,
      swLng: sw?.longitude,
      neLat: ne?.latitude,
      neLng: ne?.longitude,
      region: region
    )
    
    return .run { send in
      do {
        let result = try await categoryClient.fetchCategoryItems(categoryId, query)
        await send(.delegate(.didFetchCategoryItems(result)))
        await send(.changeBottomSheetDetent(.medium))
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

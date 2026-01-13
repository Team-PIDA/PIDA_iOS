//
//  GetFlowerSpotListDTO.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation
import APIClient
import CacheClient

struct GetFlowerSpotListDTO: DTO {
  typealias Entity = FlowerSpotListEntity
  
  var list: [FlowerSpotItemDTO]?
  
}

extension GetFlowerSpotListDTO {
  func toEntity() throws -> FlowerSpotListEntity {
    guard let list = list else { return FlowerSpotListEntity(itemList: []) }
    let items = list.compactMap {
      try? $0.toEntity()
    }
    return FlowerSpotListEntity(itemList: items)
  }
  
  func toCacheModel() -> [SearchAddressCacheModel] {
    guard let list = list else { return [] }
    return list.compactMap { item in
      SearchAddressCacheModel(
        id: item.id,
        address: item.address,
        streetName: item.streetName,
        subInfo: nil
      )
    }
  }
}


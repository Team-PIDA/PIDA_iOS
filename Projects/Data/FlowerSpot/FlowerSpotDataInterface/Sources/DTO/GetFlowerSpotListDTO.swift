//
//  GetFlowerSpotListDTO.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation
import Networker
import FlowerSpotDomainInterface

public struct GetFlowerSpotListDTO: DTO {
  public typealias Entity = FlowerSpotListEntity
  
  public var list: [FlowerSpotItem]?
  
}

extension GetFlowerSpotListDTO {
  public func toEntity() throws -> FlowerSpotListEntity {
    guard let list = list else { return FlowerSpotListEntity(itemList: []) }
    let items = list.compactMap {
      try? $0.toEntity()
    }
    return FlowerSpotListEntity(itemList: items)
  }
}




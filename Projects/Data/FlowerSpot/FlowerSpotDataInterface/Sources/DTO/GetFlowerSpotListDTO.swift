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

public struct GetFlowerSpotListDTO: DTO & Sendable{
  public typealias Entity = FlowerSpotListEntity
  
  public var list: [List]?
  
}

extension GetFlowerSpotListDTO {
  public func toEntity() throws -> FlowerSpotListEntity {
    return FlowerSpotListEntity()
  }
}

public struct List: Sendable & Decodable {
  public var id: Int
  public var address: String?
  
  public var streetName: String?
  public var district: String?
  public var description: String?
  public var geom: Geom?
  public var pinPoint: Geom?
  public var region: String?
  public var deletedAt: String?
}

public struct Geom: Sendable & Decodable {
  public var type: String?
  public var coordinates: [Double]?
}

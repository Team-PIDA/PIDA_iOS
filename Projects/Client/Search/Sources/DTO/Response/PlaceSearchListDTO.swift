//
//  PlaceSearchListDTO.swift
//  SearchClient
//
//  Created by Jiyeon on 2/1/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient
import Shared

struct PlaceSearchListDTO: DTO {
  typealias Entity = [PlaceSearchEntity]
  let district: [PlaceSearchDTO]
  let landmarks: [PlaceSearchDTO]
  let flowerSpots: [PlaceSearchDTO]
  
  func toEntity() throws -> Entity {
    var result: Entity = []
    let district = district.map { try? $0.toEntity(searchType: .district) }.compactMap { $0 }
    let landmarks = landmarks.map { try? $0.toEntity(searchType: .landmark) }.compactMap { $0 }
    let flowerSpot = flowerSpots.map { try? $0.toEntity(searchType: .flowerSpot) }.compactMap { $0 }
    result.append(contentsOf: district)
    result.append(contentsOf: landmarks)
    result.append(contentsOf: flowerSpot)
    return result
  }
  
}

struct PlaceSearchDTO: DTO {
  typealias Entity = PlaceSearchEntity
  
  let name: String
  let address: String?
  let pinPoint: PinPointDTO
  let region: String
  
  func toEntity() throws -> Entity {
    let coordinate = try pinPoint.toEntity()
    return .init(name: name, address: address, coordinate: coordinate, region: region, searchType: .flowerSpot)
  }
  
  func toEntity(searchType: SearchType) throws -> Entity {
    var data = try self.toEntity()
    data.searchType = searchType
    return data
  }
}


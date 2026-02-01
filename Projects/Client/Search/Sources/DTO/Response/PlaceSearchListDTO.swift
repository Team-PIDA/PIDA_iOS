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
  typealias Entity = [PlaceSearchListEntity]
  let district: [PlaceSearchDTO]
  let landmarks: [PlaceSearchDTO]
  let flowerSpots: [PlaceSearchDTO]
  
  func toEntity() throws -> [PlaceSearchListEntity] {
    var result: [PlaceSearchListEntity] = []
    let district = district.map { try? $0.toEntity(searchType: .region) }.compactMap { $0 }
    let landmarks = landmarks.map { try? $0.toEntity(searchType: .region) }.compactMap { $0 }
    let flowerSpot = flowerSpots.map { try? $0.toEntity(searchType: .street) }.compactMap { $0 }
    result.append(contentsOf: district)
    result.append(contentsOf: landmarks)
    result.append(contentsOf: flowerSpot)
    return result
  }
  
}

struct PlaceSearchDTO: DTO {
  typealias Entity = PlaceSearchListEntity
  
  let name: String
  let address: String?
  let pinPoint: PinPointDTO
  let region: String
  
  func toEntity() throws -> PlaceSearchListEntity {
    guard let pinPoint = try? pinPoint.toEntity() else {
      throw FoundationError.failedToDecode(PinPointDTO.self)
    }
    return .init(name: name, address: address, coordinate: pinPoint, region: region)
  }
  
  func toEntity(searchType: SearchType) throws -> PlaceSearchListEntity {
    guard let pinPoint = try? pinPoint.toEntity() else {
      throw FoundationError.failedToDecode(PinPointDTO.self)
    }
    return .init(name: name, address: address, coordinate: pinPoint, region: region, searchType: searchType)
  }
}


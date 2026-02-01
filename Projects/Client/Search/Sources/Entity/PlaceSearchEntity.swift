//
//  PlaceSearchEntity.swift
//  SearchClient
//
//  Created by Jiyeon on 2/1/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import Shared

public struct PlaceSearchListEntity: Equatable, Sendable, Codable {
  public var name: String
  public var address: String?
  public var coordinate: Coordinate
  public var region: String
  public var searchType: SearchType
  
  public init(
    name: String,
    address: String? = nil,
    coordinate: Coordinate,
    region: String,
    searchType: SearchType = .street
  ) {
    self.name = name
    self.address = address
    self.coordinate = coordinate
    self.region = region
    self.searchType = searchType
  }
}


/**
 {
   "district": [
     {
       "name": "여의도 한강공원",
       "address": "서울특별시 영등포구 여의도동",
       "pinPoint": {
         "type": "Point",
         "coordinates": [
           126.934,
           37.5284
         ]
       },
       "region": "SEOUL"
     }
   ],
   "landmarks": [
     {
       "name": "여의도 한강공원",
       "address": "서울특별시 영등포구 여의도동",
       "pinPoint": {
         "type": "Point",
         "coordinates": [
           126.934,
           37.5284
         ]
       },
       "region": "SEOUL"
     }
   ],
   "flowerSpots": [
     {
       "name": "여의도 한강공원",
       "address": "서울특별시 영등포구 여의도동",
       "pinPoint": {
         "type": "Point",
         "coordinates": [
           126.934,
           37.5284
         ]
       },
       "region": "SEOUL"
     }
   ]
 }
 */

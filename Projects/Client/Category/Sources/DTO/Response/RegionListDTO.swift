import Foundation
import APIClient
import Shared

struct RegionListDTO: DTO {
  typealias Entity = [RegionEntity]

  var list: [RegionItemDTO]?
}

extension RegionListDTO {
  func toEntity() throws -> [RegionEntity] {
    list?.map { $0.toEntity() } ?? []
  }
}

struct RegionItemDTO: DTO {
  var code: String
  var name: String

  func toEntity() -> RegionEntity {
    RegionEntity(code: Region(rawValue: code), name: name)
  }
}

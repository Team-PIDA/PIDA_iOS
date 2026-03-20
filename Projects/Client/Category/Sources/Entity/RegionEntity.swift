import Foundation
import Shared

public struct RegionEntity: Equatable, Sendable {
  public let code: Region?
  public let name: String
  
  public init(code: Region?, name: String) {
    self.code = code
    self.name = name
  }
}

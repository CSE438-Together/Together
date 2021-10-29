// swiftlint:disable all
import Amplify
import Foundation

public struct Abcc: Model {
  public let id: String
  
  public init(id: String = UUID().uuidString) {
      self.id = id
  }
}
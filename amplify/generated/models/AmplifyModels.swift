// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "a79e8597f90afef7bc6677d7afe7c475"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Abcc.self)
  }
}
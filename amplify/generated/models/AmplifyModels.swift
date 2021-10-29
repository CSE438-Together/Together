// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "62b05af285791661ed844e0e1fc7c1f8"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: AABBCC.self)
  }
}
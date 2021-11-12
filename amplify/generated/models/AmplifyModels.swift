// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "c488f82cc95db4441921c25b090e8b48"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Post.self)
  }
}
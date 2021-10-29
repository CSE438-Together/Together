// swiftlint:disable all
import Amplify
import Foundation

extension Abcc {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let abcc = Abcc.keys
    
    model.pluralName = "Abccs"
    
    model.fields(
      .id()
    )
    }
}
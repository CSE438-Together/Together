// swiftlint:disable all
import Amplify
import Foundation

extension AABBCC {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let aABBCC = AABBCC.keys
    
    model.pluralName = "AABBCCS"
    
    model.fields(
      .id()
    )
    }
}
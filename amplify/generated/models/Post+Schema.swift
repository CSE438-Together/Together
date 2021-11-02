// swiftlint:disable all
import Amplify
import Foundation

extension Post {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case author
    case departureTime
    case source
    case destination
    case transportation
    case description
    case maxMembers
    case title
    case postTime
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let post = Post.keys
    
    model.pluralName = "Posts"
    
    model.fields(
      .id(),
      .field(post.author, is: .optional, ofType: .string),
      .field(post.departureTime, is: .optional, ofType: .string),
      .field(post.source, is: .optional, ofType: .string),
      .field(post.destination, is: .optional, ofType: .string),
      .field(post.transportation, is: .optional, ofType: .string),
      .field(post.description, is: .optional, ofType: .string),
      .field(post.maxMembers, is: .optional, ofType: .int),
      .field(post.title, is: .optional, ofType: .string),
      .field(post.postTime, is: .optional, ofType: .string)
    )
    }
}
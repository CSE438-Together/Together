// swiftlint:disable all
import Amplify
import Foundation

public struct Post: Model {
  public let id: String
  public var author: String?
  public var departureTime: String?
  public var source: String?
  public var destination: String?
  public var transportation: String?
  public var description: String?
  public var maxMembers: Int?
  public var title: String?
  public var postTime: String?
  
  public init(id: String = UUID().uuidString,
      author: String? = nil,
      departureTime: String? = nil,
      source: String? = nil,
      destination: String? = nil,
      transportation: String? = nil,
      description: String? = nil,
      maxMembers: Int? = nil,
      title: String? = nil,
      postTime: String? = nil) {
      self.id = id
      self.author = author
      self.departureTime = departureTime
      self.source = source
      self.destination = destination
      self.transportation = transportation
      self.description = description
      self.maxMembers = maxMembers
      self.title = title
      self.postTime = postTime
  }
}
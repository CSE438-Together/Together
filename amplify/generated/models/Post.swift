// swiftlint:disable all
import Amplify
import Foundation

public struct Post: Model {
  public let id: String
  public var title: String?
  public var departurePlace: String?
  public var destination: String?
  public var transportation: Transportation?
  public var departureTime: Temporal.DateTime?
  public var maxMembers: Int?
  public var description: String?
  public var owner: String?
  public var members: [String]?
  public var applicants: [String]?
  
  public init(id: String = UUID().uuidString,
      title: String? = nil,
      departurePlace: String? = nil,
      destination: String? = nil,
      transportation: Transportation? = nil,
      departureTime: Temporal.DateTime? = nil,
      maxMembers: Int? = nil,
      description: String? = nil,
      owner: String? = nil,
      members: [String]? = [],
      applicants: [String]? = []) {
      self.id = id
      self.title = title
      self.departurePlace = departurePlace
      self.destination = destination
      self.transportation = transportation
      self.departureTime = departureTime
      self.maxMembers = maxMembers
      self.description = description
      self.owner = owner
      self.members = members
      self.applicants = applicants
  }
}
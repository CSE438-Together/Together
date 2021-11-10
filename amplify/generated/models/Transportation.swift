// swiftlint:disable all
import Amplify
import Foundation

public enum Transportation: String, EnumPersistable {
    case car = "CAR"
    case walk = "WALK"
    case tram = "TRAM"
    case bike = "BIKE"
    case taxi = "TAXI"
    
    public static func getInstance(of num: Int) -> Transportation {
        switch num {
        case 1:
            return .walk
        case 2:
            return .tram
        case 3:
            return .bike
        case 4:
            return .taxi
        default:
            return .car
        }
    }
}

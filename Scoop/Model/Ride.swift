//
//  Ride.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import Foundation

struct Ride: Codable {
    var id: Int
    var creator: BaseUser
    var maxTravelers: Int
    var minTravelers: Int
    var departureDatetime: String
    var description: String = ""
    var driver: BaseUser? = nil
    var isFlexible: Bool
    var riders: [BaseUser]? = []
    var estimatedCost: Int?
    var path: Path
    var type: String
}

/// This version of the Ride model is used in the approving/denying rides networking request. Is there a better way to do this? (only wanting to include certain fields of a model)
struct truncRide: Codable {
    let id: Int
    let departureDatetime: String
    let path: Path
    let type: String
}

/// Temporary, just so hardcoded data can still load while networking is not fully implemented
//extension Ride {
//    init() throws {
//        let data = try JSONSerialization.data(withJSONObject: [])
//        self = try JSONDecoder().decode(Self.self, from: data)
//    }
//}

struct RideResponse: Codable {
    var rides: [Ride]
}

class Coordinates {
    var lat: Double = 0
    var lng: Double = 0
}


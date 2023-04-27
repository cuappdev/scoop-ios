//
//  Ride.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import Foundation

class Ride: Codable {
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
    
    init(id: Int, creator: BaseUser, maxTravelers: Int, minTravelers: Int, departureDatetime: String, description: String, driver: BaseUser? = nil, isFlexible: Bool, riders: [BaseUser]? = nil, estimatedCost: Int? = nil, path: Path, type: String) {
        self.id = id
        self.creator = creator
        self.maxTravelers = maxTravelers
        self.minTravelers = minTravelers
        self.departureDatetime = departureDatetime
        self.description = description
        self.driver = driver
        self.isFlexible = isFlexible
        self.riders = riders
        self.estimatedCost = estimatedCost
        self.path = path
        self.type = type
    }
}

/// This version of the Ride model is used in the approving/denying rides networking request. Is there a better way to do this? (only wanting to include certain fields of a model)
struct TruncRide: Codable {
    let id: Int
    let departureDatetime: String
    let path: Path
    let type: String
}

struct HomeVCRide: Codable, Equatable {
    let id: Int
    var departureDatetime: String
    let path: Path
    let type: String
    let description: String
    let maxTravelers: Int
    let minTravelers: Int
    let driver: TruncUser?
    
    static func == (lhs: HomeVCRide, rhs: HomeVCRide) -> Bool {
        lhs.id == rhs.id
    }
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


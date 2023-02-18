//
//  Ride.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import Foundation

struct Ride: Codable {
    var id: String
    var creator: BaseUser
    var travelerCountLower: Int
    var travelerCountUpper: Int
    var date: String
    var details: String
    var method: String
    var driver: String
    var riders: [BaseUser]
    var estimatedCost: Int
    var path: Path
    var type: String
    
    
}

/// Temporary, just so hardcoded data can still load while networking is not fully implemented
extension Ride {
    init() throws {
        let data = try JSONSerialization.data(withJSONObject: [])
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

struct RideResponse: Codable {
    var rides: [Ride]
}

class Coordinates {
    var lat: Double = 0
    var lng: Double = 0
}


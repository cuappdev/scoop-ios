//
//  Ride.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import Foundation

class Ride {
    var id: String = ""
    var organizer = User()
    var method: String = ""
    var departureLocation = ""
    var departureCoords = Coordinates()
    var arrivalLocation = ""
    var arrivalCoords = Coordinates()
    var travelerCountLower: Int = 0
    var travelerCountUpper: Int = 0
    var date: String = ""
    var details: String = ""
    var isActive: Bool = false
}

class Coordinates {
    var lat: Double = 0
    var lng: Double = 0
}


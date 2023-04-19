//
//  Path.swift
//  Scoop
//
//  Created by Tiffany Pan on 2/15/23.
//

import Foundation

struct Path: Codable {
    var id: Int
    var startLocationPlaceId: String
    var startLocationName: String
    var startCoords: [Float]
    var endLocationPlaceId: String
    var endLocationName: String
    var endCoords: [Float]
}

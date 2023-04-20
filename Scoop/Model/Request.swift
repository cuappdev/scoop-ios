//
//  Request.swift
//  Scoop
//
//  Created by Tiffany Pan on 4/4/23.
//

import Foundation

struct RideRequest: Codable, Equatable {
    let id: Int
    let approvee: BaseUser
    let approver: BaseUser
    let ride: HomeVCRide
    var approved: Bool?
    let timestamp: String
    
    static func == (lhs: RideRequest, rhs: RideRequest) -> Bool {
        lhs.id == rhs.id
    }
}

struct RequestResponse: Codable {
    let awaitingApproval: [RideRequest]
    let pendingRequests: [RideRequest]
}

//
//  Request.swift
//  Scoop
//
//  Created by Tiffany Pan on 4/4/23.
//

import Foundation

struct Request: Codable {
    let id: Int
    let approvee: BaseUser
    let approver: BaseUser
    let ride: TruncRide
    let approved: Bool?
    let timestamp: String
}

struct RequestResponse: Codable {
    let toApprove: [Request]
    let waitingApproval: [Request]
    
    /** Use of coding keys here because backend named the keys to something unconventional for converting to/from camel case */
    enum CodingKeys: String, CodingKey {
        case toApprove = "To Approve"
        case waitingApproval = "Waiting for Approval"
    }
}

//
//  ResponseResponse.swift
//  Scoop
//
//  Created by Tiffany Pan on 3/6/23.
//

import Foundation

struct RequestResponse: Codable {
    let id: Int
    let approvee: BaseUser
    let approver: BaseUser
    // needs to be replaced with a truncated ride model, tbd need to check with Kate on this 
    let ride: Ride
    let approved: Bool
}

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
    let ride: truncRide
    let approved: Bool
}

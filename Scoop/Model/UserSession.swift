//
//  UserSession.swift
//  Scoop
//
//  Created by Richie Sun on 2/8/23.
//

import Foundation
import UIKit

struct UserSession: Codable {
    let accessToken: String
    let username: String
    let firstName: String
    let lastName: String
}

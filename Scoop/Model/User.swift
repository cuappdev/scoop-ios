//
//  User.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/19/22.
//

import Foundation
import UIKit

class User: Codable {
    var id: String = ""
    var profilePicUrl: String = ""
    var netid: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var pronouns: String = ""
    var hometown: String = ""
    var grade: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var talkingPref: Float = 0.0
    var musicPref: Float = 0.0
    var favoriteSnack: String = ""
    var favoriteSong: String = ""
    var favoriteStop: String = ""
}

struct BaseUser: Codable {
    var id: Int
    var netid: String
    var firstName: String
    var lastName: String
    var phoneNumber: String?
    var profilePicUrl: String?
    var grade: String?
    var pronouns: String?
    var prompts: [Prompt]
    var rides: [TruncRide]
}

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

class BaseUser: Codable {
    var id: Int
    var netid: String
    var firstName: String
    var lastName: String
    var phoneNumber: String?
    var profilePicUrl: String?
    var grade: String?
    var pronouns: String?
    var prompts: [Prompt]
    var rides: [HomeVCRide]
    
    init(id: Int, netid: String, firstName: String, lastName: String, phoneNumber: String? = nil, profilePicUrl: String? = nil, grade: String? = nil, pronouns: String? = nil, prompts: [Prompt], rides: [HomeVCRide]) {
        self.id = id
        self.netid = netid
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.profilePicUrl = profilePicUrl
        self.grade = grade
        self.pronouns = pronouns
        self.prompts = prompts
        self.rides = rides
    }
}

struct TruncUser: Codable {
    var id: Int
    var netid: String
    var firstName: String
    var lastName: String
    var profilePicUrl: String?
    var grade: String?
    var pronouns: String?
    var prompts: [Prompt]
}

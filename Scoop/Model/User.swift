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
    let id: Int
    let netid: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let grade: String
    let pronouns: String
    let profilePicUrl: String
}

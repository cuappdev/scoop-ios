//
//  User.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/19/22.
//

import Foundation
import UIKit

class User {
    var id: String = ""
    var profile_pic_url: String = ""
    var netid: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var pronouns: String = ""
    var hometown: String = ""
    var grade: String = ""
    var email: String = ""
    var phone_number: String = ""
    var talkingPref: Float = 0.0
    var musicPref: Float = 0.0
    var favoriteSnack: String = ""
    var favoriteSong: String = ""
    var favoriteStop: String = ""
}

class BaseUser: Codable {
    let id: Int
    let netid: String
    let first_name: String
    let last_name: String
    let phone_number: String
    let grade: String
    let pronouns: String
    let profile_pic_url: String
}

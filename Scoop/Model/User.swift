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
    var image: UIImage? = nil
    var name: String = ""
    var username: String = ""
    var pronouns: String = ""
    var hometown: String = ""
    var year: String = ""
    var email: String = ""
    var phoneNumber: String? = nil
    var talkingPref: Float = 0.0
    var musicPref: Float = 0.0
    var favoriteSnack: String = ""
    var favoriteSong: String = ""
    var favoriteStop: String = ""
}

class BaseUser: Codable {
    let id: String
    let netid: String
    let first_name: String
    let last_name: String
    let phone_number: String
    let grade: String
    let pronouns: String
}

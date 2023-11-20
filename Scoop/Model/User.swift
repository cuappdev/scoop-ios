//
//  User.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/19/22.
//

import Foundation
import UIKit

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

extension BaseUser {
    static var blockedUsersDummyData = [
        BaseUser(id: 0, netid: "netid", firstName: "Michelle", lastName: "White", phoneNumber: "phone", profilePicUrl: "", grade: "grade", pronouns: "pronouns", prompts: [], rides: []),
        BaseUser(id: 1, netid: "netid", firstName: "Lauren", lastName: "Davidson", phoneNumber: "phone", profilePicUrl: "", grade: "grade", pronouns: "pronouns", prompts: [], rides: []),
        BaseUser(id: 2, netid: "netid", firstName: "Victor", lastName: "Hunter", phoneNumber: "phone", profilePicUrl: "", grade: "grade", pronouns: "pronouns", prompts: [], rides: []),
        BaseUser(id: 3, netid: "netid", firstName: "Finley", lastName: "Carpenter", phoneNumber: "phone", profilePicUrl: "", grade: "grade", pronouns: "pronouns", prompts: [], rides: [])
    ]
}

//
//  Constants.swift
//  Scoop
//
//  Created by Richie Sun on 2/8/23.
//

import Foundation
import UIKit

struct Constants {
    
    static let accessToken = "accessToken"
    
    struct UserDefaults {
        static let id = 0
        static let netid = "netid"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let phoneNumber = "phone"
        static let profilePicUrl = ""
        static let grade = "grade"
        static let pronouns = "pronouns"
        static let prompts: [Prompt] = []
    }
    
    static let defaultUser = BaseUser(id: 0, netid: "netid", firstName: "Michelle", lastName: "lastName", phoneNumber: "phone", profilePicUrl: "", grade: "grade", pronouns: "pronouns", prompts: [], rides: [])
    
    static let defaultPath = Path(id: 0, startLocationPlaceId: "", startLocationName: "Ithaca, NY", startCoords: [], endLocationPlaceId: "", endLocationName: "Syracuse, NY", endCoords: [])
    
    struct RideDefaults {
        static let id: Int = 0
        static let creator: BaseUser = defaultUser
        static let maxTravelers: Int = 9
        static let minTravelers: Int = 0
        static let departureDatetime: String = "date-time"
        static let description: String = "description"
        static let driver: BaseUser? = nil
        static let isFlexible: Bool = true
        static let riders: [BaseUser]? = []
        static let estimatedCost: Int? = 0
        static let path: Path = defaultPath
        static let type: String = "type"
    }
    
    static let defaultRide = Ride(id: 0, creator: defaultUser, maxTravelers: 9, minTravelers: 0, departureDatetime: "2020-03-27T00:00:00Z", description: "", driver: defaultUser, isFlexible: true, path: defaultPath, type: "rideshare")
    
    static let defaultTruncRide = TruncRide(id: 0, departureDatetime: "2020-03-27T00:00:00Z", path: defaultPath, type: "type")
    
    struct RequestDefaults {
        static let id: Int = 0
        static let approvee: BaseUser = defaultUser
        static let approver: BaseUser = defaultUser
        
    }

}

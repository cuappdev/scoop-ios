//
//  Keys.swift
//  Scoop
//
//  Created by Reade Plunkett on 2/9/22.
//

import Foundation

struct Keys {
    static let googleClientID = Keys.keyDict["CLIENT_ID"] as? String ?? ""
    static let scoopedServer = Keys.keyDict["SCOOPED_SERVER_URL"] as? String ?? ""
    static let googlePlacesKey = Keys.keyDict["GOOGLE_PLACES_API_KEY"] as? String ?? ""

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
}

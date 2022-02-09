//
//  Keys.swift
//  Rideshare
//
//  Created by Reade Plunkett on 2/9/22.
//

import Foundation

struct Keys {
    static let googleClientID = Keys.keyDict["CLIENT_ID"] as? String ?? ""

//    private static let googleServiceDict: NSDictionary = {
//        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) else { return [:] }
//        return dict
//    }()

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
}

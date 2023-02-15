//
//  NetworkManager.swift
//  Scoop
//
//  Created by Richie Sun on 2/8/23.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()
    
    private static let hostEndpoint = "https//:\(Keys.scoopedServer)"
    
    static var headers: HTTPHeaders {
            let accessToken = UserDefaults.standard.string(forKey: Constants.UserDefaults.accessToken) ?? ""
            let headers: HTTPHeaders = [
                "Authorization": "Token \(accessToken)"
            ]
            return headers
        }
}

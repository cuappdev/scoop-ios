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
    
    static func searchLocation(depatureDate: String, startLocation: String, endLocation: String, completion: @escaping (RideResponse) -> Void) {
        let endpoint = "https://scoop-prod.cornellappdev.com/api/search/"
        
        let params = [
            "departure_datetime": depatureDate,
            "start_location_name": startLocation,
            "end_location_name": endLocation
        ]
        
        AF.request(endpoint, method: .get, parameters: params).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let ridesResponse = try? jsonDecoder.decode(RideResponse.self, from: data) {
                    completion(ridesResponse)
                } else {
                    print("Failed to decode searchLocation from JSON")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

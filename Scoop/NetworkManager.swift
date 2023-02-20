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
    
    func searchLocation(depatureDate: String, startLocation: String, endLocation: String, completion: @escaping (RideResponse) -> Void) {
        let endpoint = "\(NetworkManager.hostEndpoint)/api/search/"
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
    
    func getAllRides(completion: @escaping(RideResponse) -> Void) {
        let endpoint = "\(NetworkManager.hostEndpoint)/api/rides/"
        
        AF.request(endpoint, method: .get).validate().responseData { response in
        switch (response.result) {
        case .success(let data):
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            if let ridesResponse = try? jsonDecoder.decode(RideResponse.self, from: data) {
                completion(ridesResponse)
            } else {
                print("Failed to decode getAllRides from JSON")
            }
        case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
    
    func getSpecificRide(rideID: Int, completion: @escaping(Ride) -> Void) {
        let endpoint = "\(NetworkManager.hostEndpoint)/api/ride/\(rideID)/"
        
        AF.request(endpoint, method: .get).validate().responseData { response in
        switch (response.result) {
        case .success(let data):
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            if let ridesResponse = try? jsonDecoder.decode(Ride.self, from: data) {
                completion(ridesResponse)
            } else {
                print("Failed to decode getSpecific Ride from JSON")
            }
        case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }
    
    func postRide(startID: Int, startName: String, endID: Int, endName: String, creator: BaseUser, maxTravellers: Int, minTravellers: Int, type: String, isFlexible: Bool, departureTime: String, completion: @escaping(Ride) -> Void) {
        let endpoint = "\(NetworkManager.hostEndpoint)/api/ride/"
        let params: [String : Any] = [
            "start_location_place_id": startID,
            "start_location_name": startName,
            "end_location_place_id": endID,
            "end_location_name": endName,
            "creator": creator,
            "max_travelers": maxTravellers,
            "min_travelers": minTravellers,
            "type": type,
            "is_flexible": isFlexible,
            "departure_datetime": departureTime
        ]
        
        AF.request(endpoint, method: .post, parameters: params).validate().responseData { response in
        switch (response.result) {
        case .success(let data):
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            if let ride = try? jsonDecoder.decode(Ride.self, from: data) {
                completion(ride)
            } else {
                print("Failed to decode postRide from JSON")
            }
        case .failure(let error):
            print(error.localizedDescription)
            }
        }
    }

}

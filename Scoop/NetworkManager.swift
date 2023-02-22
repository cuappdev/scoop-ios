//
//  NetworkManager.swift
//  Scoop
//
//  Created by Richie Sun on 2/8/23.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var currentUser = User() //Swap with BaseUser once backend finishes profile routes
    
    static var userToken = Constants.UserDefaults.accessToken
    
    static let shared: NetworkManager = NetworkManager()
    
    private let hostEndpoint = "https://\(Keys.scoopedServer)"
    
    private var headers: HTTPHeaders {
        let accessToken = NetworkManager.userToken
        let headers: HTTPHeaders = [
            "Authorization": "Token \(accessToken)"
            ]
        return headers
        }
    
    func authenticateUser(googleID: String, email: String, firstName: String, lastName: String, id_token: String, completion: @escaping (Result<UserSession, Error>) -> Void) {
        let parameters: [String : String] = [
            "sub": googleID,
            "email": email,
            "given_name": firstName,
            "family_name": lastName,
            "id_token": id_token
        ]
        AF.request("\(hostEndpoint)/api/authenticate/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let userData = try jsonDecoder.decode(UserSession.self, from: data)
                    completion(.success(userData))
                } catch {
                    completion(.failure(error))
                    print("Failed to decode authenticateUser")
                }
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    func updateAuthenticatedUser(netid: String, first_name: String, last_name: String, grade: String, phone_number: String, pronouns: String, prof_pic: String, completion: @escaping (Result<BaseUser, Error>) -> Void) {
            let parameters: [String: String] = [
                "netid": netid,
                "first_name": first_name,
                "last_name": last_name,
                "grade": grade,
                "phone_number": phone_number,
                "pronouns": pronouns,
                "profile_pic_base64": prof_pic
            ]
        AF.request("\(hostEndpoint)/api/me/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        let authUser = try jsonDecoder.decode(BaseUser.self, from: data)
                        completion(.success(authUser))
                    } catch {
                        completion(.failure(error))
                        print("Failed to decode updateAuthenticatedUser")
                    }
                case .failure(let error):
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
        }
    
    func getUser(completion: @escaping (Result<BaseUser, Error>) -> Void) {
        AF.request("\(hostEndpoint)/api/me/", method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let user = try jsonDecoder.decode(BaseUser.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                    print("Failed to decode getUser")
                }
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Debugging Developer Requests
    func getAllUsers(completion: @escaping (Result<[BaseUser], Error>) -> Void ) {
        AF.request("\(hostEndpoint)/api/dev/", method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let allUsers = try jsonDecoder.decode([BaseUser].self, from: data)
                    completion(.success(allUsers))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
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

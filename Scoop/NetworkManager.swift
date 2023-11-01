//
//  NetworkManager.swift
//  Scoop
//
//  Created by Richie Sun on 2/8/23.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var currentUser = Constants.defaultUser
    var currentRide = Constants.defaultRide
    var userPromptAnswers: [UserAnswer] = []
    weak var profileDelegate: ProfileViewDelegate?
    
    static var userToken = Constants.accessToken
    
    static let shared: NetworkManager = NetworkManager()
    
    private let hostEndpoint = "https://\(Keys.scoopedServer)"
    
    private var headers: HTTPHeaders {
        let accessToken = NetworkManager.userToken
        let headers: HTTPHeaders = [
            "Authorization": "Token \(accessToken)"
            ]
        return headers
        }
    
    // MARK: - User Functions
    
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
                print("Request authenticateUser Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func updateAuthenticatedUser(netid: String, first_name: String, last_name: String, grade: String, phone_number: String, pronouns: String, prof_pic: String, prompts: [UserAnswer], completion: @escaping (Result<BaseUser, Error>) -> Void) {
            print(prompts.map({ prompt -> [String: Any] in
                return [
                    "id": prompt.id,
                    "answer": prompt.answer
                ]
        }))
            let parameters: [String: Any] = [
                "netid": netid,
                "first_name": first_name,
                "last_name": last_name,
                "grade": grade,
                "phone_number": phone_number,
                "pronouns": pronouns,
                "profile_pic_base64": prof_pic,
                "prompts": prompts.map({ prompt -> [String: Any] in
                        return [
                            "id": prompt.id,
                            "answer": prompt.answer
                        ]
                })
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
                    print("Request updateAuthenticatedUser Failed: \(error.localizedDescription)")
                }
            }
        }

    func deleteUser(
        netid: String,
        first_name: String,
        last_name: String,
        grade: String,
        phone_number: String,
        pronouns: String,
        prof_pic: String,
        prompts: [UserAnswer],
        completion: @escaping (Result<BaseUser, Error>) -> Void
    ) {
        let parameters: [String: Any] = [
            "netid": netid,
            "first_name": first_name,
            "last_name": last_name,
            "grade": grade,
            "phone_number": phone_number,
            "pronouns": pronouns,
            "profile_pic_base64": prof_pic,
            "prompts": prompts.map({ return ["id": $0.id, "answer": $0.answer] as [String : Any] })
        ]

        AF.request("\(hostEndpoint)/api/me/", method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                print("Request deleteUser Success")
            case .failure(let error):
                completion(.failure(error))
                print("Request deleteUser Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func getUser(completion: @escaping (Result<BaseUser, Error>) -> Void) {
        AF.request("\(hostEndpoint)/api/me/", method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
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
                print("Request getUser Failed: \(error.localizedDescription)")
            }
        }
    }
    
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
                print("Request getAllUsers Failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Prompt Functions
    
    func postPrompt(name: String, placeholder: String, completion: @escaping(Result<Prompt, Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/prompts/"
        let params = [
            "question_name": name,
            "question_placeholder": placeholder
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let prompt = try jsonDecoder.decode(Prompt.self, from: data)
                    completion(.success(prompt))
                } catch {
                    completion(.failure(error))
                    print("Failed to decode postPrompt")
                }
            case .failure(let error):
                completion(.failure(error))
                print("Request postPrompt Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func updatePrompt(id: Int, name: String, placeholder: String, completion: @escaping(Result<Prompt, Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/prompts/\(id)/"
        let params = [
            "question_name": name,
            "question_placeholder": placeholder
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let prompt = try jsonDecoder.decode(Prompt.self, from: data)
                    completion(.success(prompt))
                } catch {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion(.failure(error))
                print("Request updatePrompt Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func getAllPrompts(completion: @escaping(Result<[Prompt], Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/prompts/"
        
        AF.request(endpoint, method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let prompts = try jsonDecoder.decode([Prompt].self, from: data)
                    completion(.success(prompts))
                } catch {
                    completion(.failure(error))
                    print("Failed to decode getAllPrompts")
                }
            case .failure(let error):
                completion(.failure(error))
                print("Request getAllPrompts Failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Location Search Functions
    
    func searchLocation(depatureDate: String, startLocation: String, endLocation: String, completion: @escaping (Result<[Ride], Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/search/"
        let parameters : [String: Any] = [
            "departure_datetime": depatureDate,
            "start_location_place_id": startLocation,
            "end_location_place_id": endLocation,
            "radius": 5
        ]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            print(parameters)
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let filteredRides = try jsonDecoder.decode([Ride].self, from: data)
                    completion(.success(filteredRides))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                print("Request searchLocation Failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Ride Functions
    
    func getAllRides(completion: @escaping(Result<[Ride], Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/rides/"
        
        AF.request(endpoint, method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                jsonDecoder.dateDecodingStrategy = .iso8601
                do {
                    let allRides = try jsonDecoder.decode([Ride].self, from: data)
                    completion(.success(allRides))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                print("Request getAllRides Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func getSpecificRide(rideID: Int, completion: @escaping(Result<Ride, Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/ride/\(rideID)/"
        
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let ride = try jsonDecoder.decode(Ride.self, from: data)
                    completion(.success(ride))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                print("Request getSpecific Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func postRide(startID: String, startName: String, endID: String, endName: String, driver: Int, creator: Int, maxTravellers: Int, minTravellers: Int, type: String, isFlexible: Bool, departureTime: String, description: String, completion: @escaping(Result<Ride, Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/rides/"
        let params: [String : Any] = [
            "start_location_place_id": startID,
            "start_location_name": startName,
            "end_location_place_id": endID,
            "end_location_name": endName,
            "creator": creator,
            "description": description,
            "max_travelers": maxTravellers,
            "min_travelers": minTravellers,
            "type": type,
            "is_flexible": isFlexible,
            "departure_datetime": departureTime,
            "driver": driver
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let ride = try jsonDecoder.decode(Ride.self, from: data)
                    completion(.success(ride))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                print("Request postRide Failed: \(error.localizedDescription)")
            }
        }
    }
    
    /** IMPORTANT: To remove a driver from ride, pass in null value for driver. Otherwise, must pass in same driver every time even if set before. To update riders, pass in a list of ALL the new rider ids (even if they have been previously added). */
    func updateRide(driverID: Int, riders: [Int], rideID: Int, completion: @escaping(Result<Ride, Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/rides/\(rideID)"
        let params: [String : Any] = [
            "driver": driverID,
            "riders": riders
        ]
        
        AF.request(endpoint, method: .post, parameters: params).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let ride = try jsonDecoder.decode(Ride.self, from: data)
                    completion(.success(ride))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                print("Request updateRide Failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Ride Request Functions
    
    func handleRideRequest(requestID: Int, approved: Bool, completion: @escaping(Result<RideRequest, Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/requests/\(requestID)/"
        let params = [
            "approved": approved
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let request = try jsonDecoder.decode(RideRequest.self, from: data)
                    completion(.success(request))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                print("Request handleRideRequest Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func getAllRequests(completion: @escaping(Result<RequestResponse, Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/requests/"
        
        AF.request(endpoint, method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let requests = try jsonDecoder.decode(RequestResponse.self, from: data)
                    completion(.success(requests))
                } catch {
                    completion(.failure(error))
                    print("Failed to decode getAllRequests")
                }
            case .failure(let error):
                completion(.failure(error))
                print("Unable to get all requests: \(error.localizedDescription)")
            }
        }
    }
    
    func postRequest(approveeID: Int, rideID: Int, completion: @escaping(Result<RideRequest, Error>) -> Void) {
        let endpoint = "\(hostEndpoint)/api/requests/"
        let params = [
            "approvee_id": approveeID,
            "ride_id": rideID
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let request = try jsonDecoder.decode(RideRequest.self, from: data)
                    completion(.success(request))
                } catch {
                    completion(.failure(error))
                    print("Failed to decode postRequest")
                }
            case .failure(let error):
                completion(.failure(error))
                print("Unable to postRequest: \(error.localizedDescription)")
            }
        }
    }
    
}

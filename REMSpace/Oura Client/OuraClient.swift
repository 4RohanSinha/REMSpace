//
//  OuraClient.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/7/23.
//

import Foundation
import UIKit

class OuraClient {
    
    
    enum Endpoints {
        static let clientID = "J473YMTWVVVSJXKA"
        static let clientSecret = "4ZTJJQCEN4FG326JZGXNTDHEHSKJS4KV"
        static let urlBase = "https://api.ouraring.com/v2"
        
        case loginOauth
        case fetchPersonalInfo
        case fetchSleepData(String, String)
        
        var stringValue: String {
            switch self {
            case .loginOauth:
                return "https://cloud.ouraring.com/oauth/authorize?response_type=token&client_id=\(OuraClient.Endpoints.clientID)&redirect_uri=remspace%3Aauthenticate&scope=email+personal+daily"
            case .fetchPersonalInfo:
                return OuraClient.Endpoints.urlBase + "/usercollection/personal_info"
            case .fetchSleepData(let startDate, let endDate):
                return "https://api.ouraring.com/v2/usercollection/daily_sleep?start_date=\(startDate)&end_date=\(endDate)"
                //return "http://192.168.1.76:3000/sleepData?start_date=\(startDate)&end_date=\(endDate)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func fetchPersonalInfo(completion: @escaping (OuraPersonalInfoResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.fetchPersonalInfo.url, response: OuraPersonalInfoResponse.self, completion: completion)
    }
    
    class func fetchSleepData(completion: @escaping (OuraSleepResponse?, Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        taskForGETRequest(url: Endpoints.fetchSleepData("01-01-1990", dateFormatter.string(from: Date())).url, response: OuraSleepResponse.self, completion: completion)
    }
        
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let authToken = "Bearer \(String(describing: UserDefaults.standard.string(forKey: "ouraAccessToken")!))"
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    
    
}

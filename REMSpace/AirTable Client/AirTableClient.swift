//
//  AirTableClient.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/9/23.
//

import Foundation

class AirTableClient {
    private static let baseID = "appDlI7Tcwx0RVJWr"
    private static let tableName = "Tasks"
    private static let authToken = "patq1wKzNmumH5Y9y.9edcb2f99ae4009f123d81cd5501122ba9ad07b802a77d570935f08dca2358f9"
    
    class func getActivities(completion: @escaping (AirTableActivityResponse?, Error?) -> ()) -> URLSessionTask {
        var request = URLRequest(url: URL(string: "https://api.airtable.com/v0/\(baseID)/\(tableName)")!)
        request.httpMethod = "GET"
        
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            guard let data = data else {
                completion(nil, err)
                return
            }
            
            do {
                let airTableRes = try JSONDecoder().decode(AirTableActivityResponse.self, from: data)
                completion(airTableRes, nil)
            } catch {
                completion(nil, error)
            }
            
        }
        
        task.resume()
        
        return task
    }
}

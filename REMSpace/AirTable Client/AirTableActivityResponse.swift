//
//  AirTableActivityResponse.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/9/23.
//

import Foundation

class AirTableActivityResponse: Codable {
    var records: [AirTableActivity]
}

class AirTableActivity: Codable {
    var id: String
    var createdTime: String
    var fields: AirTableActivityFields
}

class AirTableActivityFields: Codable {
    var description: String
    var tags: [String]
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case description = "Description"
        case tags = "Tags"
        case name = "Name"
    }
}

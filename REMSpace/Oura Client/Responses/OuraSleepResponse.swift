//
//  OuraSleepResponse.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/9/23.
//

import Foundation

class OuraSleepResponse: Codable {
    var data: [OuraSleepLog]
    var next_token: String
}

class OuraSleepLog: Codable {
    var id: String
    var day: String
    var timestamp: String
    var score: Int
    var contributors: OuraSleepLogContributors

}

class OuraSleepLogContributors: Codable {
    var deep_sleep: Int
    var efficiency: Int
    var latency: Int
    var rem_sleep: Int
    var restfulness: Int
    var timing: Int
    var total_sleep: Int
}

//
//  OuraAccessTokenRequest.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/7/23.
//

import Foundation

struct OuraAccessTokenRequest: Codable {
    var grant_type: String //= "authorization_code" || "refresh_token"
    var code: String
    //let refresh_token: String?
    var redirect_uri = "remspace:authenticate"
    var client_id = OuraClient.Endpoints.clientID
    //var client_secret = OuraClient.Endpoints.clientSecret
}

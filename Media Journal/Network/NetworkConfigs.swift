//
//  NetworkConfigs.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/21/23.
//

import Foundation

struct TMDbAPIConfig {
    static let baseURL = "https://api.themoviedb.org"
    static let imagePath = "https://image.tmdb.org/t/p/w500"
    
    static var apiToken: String? {
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            return token
        } else {
            fatalError("API_TOKEN not found in Info.plist")
        }
    }
    
    static var headers: [String: String] {
        [
            "accept": "application/json",
            "Authorization": "Bearer \(apiToken ?? "")"
        ]
    }
}

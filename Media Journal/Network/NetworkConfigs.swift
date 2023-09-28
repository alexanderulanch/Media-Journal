//
//  NetworkConfigs.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/21/23.
//

import Foundation

struct TMDbAPIConfig {
    static let baseURL = "https://api.themoviedb.org"
    static let imageUrl = "https://image.tmdb.org/t/p/w500"
    static let backdropUrl = "https://image.tmdb.org/t/p/w1280"
    
    static var apiToken: String? {
        if let token = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_TOKEN") as? String {
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

struct YoutubeAPIConfig {
    static let baseURL = "https://youtube.googleapis.com/youtube/v3"
    
    static var apiToken: String? {
        if let token = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_TOKEN") as? String {
            return token
        } else {
            fatalError("GOOGLE_API_TOKEN not found in Info.plist")
        }
    }
    
    static var headers: [String: String] {
        [
            "accept": "application/json"
        ]
    }
}

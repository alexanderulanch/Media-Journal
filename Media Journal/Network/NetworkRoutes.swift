//
//  NetworkRoutes.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/21/23.
//

import Foundation

typealias Headers = [String: String]

protocol Endpoint {
    var route: String { get }
    var baseURL: String { get }
    var headers: Headers { get }
    var httpMethod: String { get }
    var urlPath: String { get }
    var parameters: [String: Any?] { get }
}

enum YoutubeEndpoint: Endpoint {
    case youtubeVideo(_ id: String)
    
    var route: String {
        switch self {
        case .youtubeVideo:
            return "/videos"
        }
    }
    
    var baseURL: String {
        YoutubeAPIConfig.baseURL
    }
    
    var headers: Headers {
        YoutubeAPIConfig.headers
    }
    
    var httpMethod: String {
        "get"
    }
    
    var urlPath: String {
        switch self {
        case .youtubeVideo:
            baseURL + route
        }
    }
    var parameters: [String : Any?] {
        switch self {
        case .youtubeVideo(let id):
            return [
                "id": id,
                "part": "snippet",
                "key" : YoutubeAPIConfig.apiToken
            ]
        }
    }
}

enum TMDBEndpoint: Endpoint {
    case searchCollection(_ query: String)
    case searchKeyword(_ query: String)
    case searchMovie(_ query: String)
    case searchMulti(_ query: String)
    case searchPerson(_ query: String)
    case searchTV(_ query: String)
    case movieDetails(_ id: Int)
    case credits(_ id: Int)
    case releaseDates(_ id: Int)
    case movieVideos(_ id: Int)
    
    var route: String {
        switch self {
        case .searchCollection:
            "/3/search/collection"
        case .searchKeyword:
            "/3/search/keyword"
        case .searchMovie:
            "/3/search/movie"
        case .searchMulti:
            "/3/search/multi"
        case .searchPerson:
            "/3/search/person"
        case .searchTV:
            "/3/search/tv"
        case .movieDetails(let id):
            "/3/movie/\(id)"
        case .credits(let id):
            "/3/movie/\(id)/credits"
        case .releaseDates(let id):
            "/3/movie/\(id)/release_dates"
        case .movieVideos(let id):
            "/3/movie/\(id)/videos"
        }
    }
    
    var headers: Headers {
        TMDbAPIConfig.headers
    }
    
    var httpMethod: String {
        switch self {
        default:
            "GET"
        }
    }
    
    var baseURL: String {
        TMDbAPIConfig.baseURL
    }
    
    var urlPath: String {
        baseURL + route
    }
    
    var parameters: [String: Any?] {
        switch self {
        case .searchCollection(let query):
            return [
                "query": query,
                "include_adult": false,
                "language": "en-US",
                "page": 1,
                "region": nil
            ]
        case .searchKeyword(let query):
            return [
                "query": query,
                "page": 1
            ]
        case .searchMovie(let query):
            return [
                "query": query,
                "include_adult": false,
                "language": "en-US",
                "primary_release_year": nil,
                "page": 1,
                "region": nil,
                "year": nil
            ]
        case .searchMulti(let query):
            return [
                "query": query,
                "include_adult": false,
                "language": "en-US",
                "page": 1
            ]
        case .searchPerson(let query):
            return [
                "query": query,
                "include_adult": false,
                "language": "en-US",
                "page": 1
            ]
        case .searchTV(let query):
            return [
                "query": query,
                "first_air_date_year": nil,
                "include_adult": false,
                "language": "en-US",
                "page": 1,
                "year": nil
            ]
        case .movieDetails:
            return [
                "append_to_response" : nil,
                "language": "en-US"
            ]
        case .credits:
            return [
                "language": "en-US"
            ]
        case .movieVideos:
            return [
                "language": "en-US"
            ]
        default :
            return [:]
        }
    }
}

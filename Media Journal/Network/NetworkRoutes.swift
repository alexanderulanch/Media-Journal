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

enum TMDBEndpoint: Endpoint {
    case searchCollection
    case searchKeyword
    case searchMovie
    case searchMulti
    case searchPerson
    case searchTV
    case movie
    case credits

    var route: String {
        switch self {
        case .searchCollection:
            return "/3/search/collection"
        case .searchKeyword:
            return "/3/search/keyword"
        case .searchMovie:
            return "/3/search/movie"
        case .searchMulti:
            return "/3/search/multi"
        case .searchPerson:
            return "/3/search/person"
        case .searchTV:
            return "/3/search/tv"
        case .movie:
            return "/3/movie"
        case .credits:
            return "/3/movie"
        }
    }

    var headers: Headers {
            return TMDbAPIConfig.headers
        }

    var httpMethod: String {
        switch self {
        default:
            return "GET"
        }
    }

    var baseURL: String {
        return TMDbAPIConfig.baseURL
    }

    var urlPath: String {
        baseURL + route
    }
    
    var parameters: [String: Any?] {
        switch self {
        case .searchCollection:
            return [
                "include_adult": false,
                "language": "en-US",
                "page": 1,
                "region": nil
            ]
        case .searchKeyword:
            return [
                "page": 1
            ]
        case .searchMovie:
            return [
                "include_adult": false,
                "language": "en-US",
                "primary_release_year": nil,
                "page": 1,
                "region": nil,
                "year": nil
            ]
        case .searchMulti:
            return [
                "include_adult": false,
                "language": "en-US",
                "page": 1
            ]
        case .searchPerson:
            return [
                "include_adult": false,
                "language": "en-US",
                "page": 1
            ]
        case .searchTV:
            return [
                "first_air_date_year": nil,
                "include_adult": false,
                "language": "en-US",
                "page": 1,
                "year": nil
            ]
        case .movie:
            return [
                "append_to_response": nil,
                "language": "en-US"
            ]
        case .credits:
            return [
                "language": "en-US"
            ]
        }
    }
}

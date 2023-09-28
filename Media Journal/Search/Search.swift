//
//  Search.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/15/23.
//

import Foundation

struct SearchResponse: Codable {
    let page: Int
    let results: [SearchResult]
    let totalPages: Int
    let totalResults: Int
}

struct SearchResult: Identifiable, Codable {
    let id: Int?
    let adult: Bool?
    let name: String?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let genreIds: [Int]?
    let originalTitle: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let originCountry: [String]?
    let gender: Int?
    let knownFor: [SearchResult]?
    let knownForDepartment: String?
    let firstAirDate: String?
    let mediaType: String?
    
    private let backdropPath: String?
    private let posterPath: String?
    private let profilePath: String?

    var backdropURL: URL? {
        if let path = backdropPath {
            return URL(string: "\(TMDbAPIConfig.imageUrl + path)")
        }
        return nil
    }
    var posterURL: URL? {
        if let path = posterPath {
            return URL(string: "\(TMDbAPIConfig.imageUrl + path)")
        }
        return nil
    }
    var profileURL: URL? {
        if let path = profilePath {
            return URL(string: "\(TMDbAPIConfig.imageUrl + path)")
        }
        return nil
    }
}

enum SearchType {
    case collection(String)
    case keyword(String)
    case movie(String)
    case multi(String)
    case person(String)
    case tvShow(String)
    
    var description: String {
        switch self {
        case .collection:
            return "Collections"
        case .keyword:
            return "Keyword"
        case .movie:
            return "Movies"
        case .multi:
            return "Multi"
        case .person:
            return "Person"
        case .tvShow:
            return "TV Shows"
        }
    }
    
    var endpoint: Endpoint {
        switch self {
        case .collection(let query):
            return TMDBEndpoint.searchCollection(query)
        case .keyword(let query):
            return TMDBEndpoint.searchKeyword(query)
        case .movie(let query):
            return TMDBEndpoint.searchMovie(query)
        case .multi(let query):
            return TMDBEndpoint.searchMulti(query)
        case .person(let query):
            return TMDBEndpoint.searchPerson(query)
        case .tvShow(let query):
            return TMDBEndpoint.searchTV(query)
        }
    }
}


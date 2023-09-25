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
            return URL(string: "\(TMDbAPIConfig.imagePath + path)")
        }
        return nil
    }
    var posterURL: URL? {
        if let path = posterPath {
            return URL(string: "\(TMDbAPIConfig.imagePath + path)")
        }
        return nil
    }
    var profileURL: URL? {
        if let path = profilePath {
            return URL(string: "\(TMDbAPIConfig.imagePath + path)")
        }
        return nil
    }
}

enum SearchType: String, CaseIterable {
    case collection = "Collections"
    case keyword
    case movie = "Movies"
    case multi
    case person
    case tvShow = "TV Shows"
    
    var endpoint: Endpoint {
        switch self {
        case .collection:
            return TMDBEndpoint.searchCollection
        case .keyword:
            return TMDBEndpoint.searchKeyword
        case .movie:
            return TMDBEndpoint.searchMovie
        case .multi:
            return TMDBEndpoint.searchMulti
        case .person:
            return TMDBEndpoint.searchPerson
        case .tvShow:
            return TMDBEndpoint.searchTV
        }
    }
}

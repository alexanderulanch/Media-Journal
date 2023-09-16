//
//  SearchResponse.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/15/23.
//

import Foundation

struct SearchResponse: Codable {
    let page: Int
    let results: [Media]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Media: Codable, Identifiable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let title: String?
    let name: String?
    let gender: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalTitle: String?
    let originalName: String?
    let overview: String?
    let firstAirDate: String?
    let genreIds: [Int]?
    let mediaType: String?
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let knownForDepartment: String?
    let knownFor: [Media]?
    
    private let profilePath: String?
    private let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case title
        case name
        case gender
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case genreIds = "genre_ids"
        case mediaType = "media_type"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w500"
        return URL(string: baseURL + backdropPath)
    }
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w500"
        return URL(string: baseURL + posterPath)
    }
}
enum MediaType {
    case movie
    case tv
    case person
}

//
//  SearchResponse.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/15/23.
//

import Foundation

struct SearchResponse<T: SearchResultItem>: Codable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Collection: Codable, Identifiable, SearchResultItem {
    let adult: Bool
    let id: Int
    let name: String?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    
    private let backdropPath: String?
    private let posterPath: String?
    
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
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
    }
}

struct Company: Codable, Identifiable, SearchResultItem {
    let id: Int
    let name: String?
    let originCountry: String?
    
    private let logoPath: String?
    
    var logoURL: URL? {
        guard let logoPath = logoPath else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w500"
        return URL(string: baseURL + logoPath)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

struct Keyword: Codable, Identifiable, SearchResultItem {
    let id: Int
    let name: String?
}

struct Movie: Codable, Identifiable, SearchResultItem {
    let adult: Bool
    let genreIDs: [Int]?
    let id: Int
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    private let backdropPath: String?
    private let posterPath: String?
    
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
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct Multi: Codable, Identifiable, SearchResultItem {
    let adult: Bool
    let genreIDs: [Int]?
    let id: Int
    let mediaType: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    private let backdropPath: String?
    private let posterPath: String?
    
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
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct Person: Codable, Identifiable, SearchResultItem {
    let adult: Bool
    let gender: Int?
    let id: Int
    let knownFor: [Multi]?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    
    var profileURL: URL? { // TODO: Update Base URl
        guard let backdropPath = profilePath else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w500"
        return URL(string: baseURL + backdropPath)
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
    }
}

struct TV: Codable, Identifiable, SearchResultItem {
    let adult: Bool
    let firstAirDate: String?
    let genreIDs: [Int]?
    let id: Int
    let name: String?
    let originalCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let voteAverage: Double?
    let voteCount: Int?
    
    private let backdropPath: String?
    private let posterPath: String?
    
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
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDs = "genre_ids"
        case id
        case name
        case originalCountry = "original_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

protocol SearchResultItem: Codable, Identifiable {
    var id: Int { get }
}

enum SearchType {
    case collection
    case company
    case keyword
    case movie
    case multi
    case person
    case tvShow
}
    

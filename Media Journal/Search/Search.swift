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
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SearchResult: Identifiable, Codable {
    let id: Int?
    let adult: Bool?
    let name: String?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let genreIDs: [Int]?
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

    // Image/Logo URLs
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
    var logoURL: URL? {
        if let path = logoPath {
            return URL(string: "\(TMDbAPIConfig.imagePath + path)")
        }
        return nil
    }

    // Image/Logo paths
    private let backdropPath: String?
    private let posterPath: String?
    private let profilePath: String?
    private let logoPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case genreIDs = "genre_ids"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
        case gender
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case firstAirDate = "first_air_date"
        case mediaType = "media_type"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
        case logoPath = "logo_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try? container.decode(Int.self, forKey: .id)
        adult = try? container.decode(Bool.self, forKey: .adult)
        name = try? container.decode(String?.self, forKey: .name)
        originalLanguage = try? container.decode(String?.self, forKey: .originalLanguage)
        originalName = try? container.decode(String?.self, forKey: .originalName)
        overview = try? container.decode(String?.self, forKey: .overview)
        popularity = try? container.decode(Double?.self, forKey: .popularity)
        genreIDs = try? container.decode([Int]?.self, forKey: .genreIDs)
        originalTitle = try? container.decode(String?.self, forKey: .originalTitle)
        releaseDate = try? container.decode(String?.self, forKey: .releaseDate)
        title = try? container.decode(String?.self, forKey: .title)
        video = try? container.decode(Bool?.self, forKey: .video)
        voteAverage = try? container.decode(Double?.self, forKey: .voteAverage)
        voteCount = try? container.decode(Int?.self, forKey: .voteCount)
        gender = try? container.decode(Int?.self, forKey: .gender)
        knownFor = try? container.decode([SearchResult]?.self, forKey: .knownFor)
        knownForDepartment = try? container.decode(String?.self, forKey: .knownForDepartment)
        firstAirDate = try? container.decode(String?.self, forKey: .firstAirDate)
        mediaType = try? container.decode(String?.self, forKey: .mediaType)
        backdropPath = try? container.decode(String?.self, forKey: .backdropPath)
        posterPath = try? container.decode(String?.self, forKey: .posterPath)
        logoPath = try? container.decode(String?.self, forKey: .logoPath)
        profilePath = try? container.decode(String?.self, forKey: .profilePath)

        if let countriesArray = try? container.decode([String].self, forKey: .originCountry) {
            originCountry = countriesArray
        } else if let singleCountry = try? container.decode(String.self, forKey: .originCountry) {
            originCountry = [singleCountry]
        } else {
            originCountry = nil
        }
    }
}

enum SearchType: String, CaseIterable {
    case collection = "Collections"
    case company
    case keyword
    case movie = "Movies"
    case multi
    case person
    case tvShow = "TV Shows"
    
    var endpoint: Endpoint {
        switch self {
        case .collection:
            return TMDBEndpoint.searchCollection
        case .company:
            return TMDBEndpoint.searchCompany
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

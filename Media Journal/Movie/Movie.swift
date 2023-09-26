//
//  Movie.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/23/23.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let imbdId: String?
    let adult: Bool?
    let belongsToCollection: Collection?
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let productionCompanies: [Company]?
    let productionCountries: [Country]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguage: [Language]?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    private let backdropPath: String?
    private let posterPath: String?
    
    var backdropURL: URL? {
        if let path = backdropPath {
            return URL(string: "\(TMDbAPIConfig.backdropPath + path)")
        }
        return nil
    }
    var homepageURL: URL? {
        if let path = homepage {
            return URL(string: path)
        }
        return nil
    }
    var posterURL: URL? {
        if let path = posterPath {
            return URL(string: "\(TMDbAPIConfig.imagePath + path)")
        }
        return nil
    }
}

struct Genre: Codable, Identifiable {
    let id: Int?
    let name: String?
}

struct Company: Codable, Identifiable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
}

struct Country: Codable {
    let iso31661: String?
    let name: String?
}

struct Language: Codable {
    let englishName: String?
    let iso6391: String?
    let name: String?
}

struct Collection: Codable, Identifiable {
    let id: Int?
    let name: String?
    
    private let posterPath: String?
    private let backdropPath: String?
    
    var posterURL: URL? {
        if let path = posterPath {
            return URL(string: "\(TMDbAPIConfig.imagePath + path)")
        }
        return nil
    }
    var backdropURL: URL? {
        if let path = backdropPath {
            return URL(string: "\(TMDbAPIConfig.imagePath + path)")
        }
        return nil
    }
}

struct Credits: Codable, Identifiable {
    let id: Int?
    let cast: [CastMember]?
    let crew: [CrewMember]?
}

struct CastMember: Codable, Identifiable {
    let id: Int?
    let adult: Bool?
    let gender: Int?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String?
    let order: Int?
}

struct CrewMember: Codable, Identifiable {
    let id: Int?
    let adult: Bool?
    let gender: Int?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let creditId: String?
    let department: String?
    let job: String?
}

struct ReleaseDateResponse: Codable, Identifiable {
    let id: Int?
    let results: [ReleaseDateResult]?
}

struct ReleaseDateResult: Codable {
    let iso31661: String?
    let releaseDates: [ReleaseDate]?
}

struct ReleaseDate: Codable {
    let certification: String?
    let descriptors: [String]?
    let iso6391: String?
    let note: String?
    let releaseDate: String?
    let type: Int?
}

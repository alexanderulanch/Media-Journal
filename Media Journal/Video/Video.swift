//
//  Video.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/26/23.
//

import Foundation

struct YoutubeVideoResponse: Codable {
    let kind: String
    let etag: String
    let items: [YoutubeVideo]
    let pageInfo: PageInfo
}

struct YoutubeVideo: Codable {
    let kind: String
    let etag: String
    let id: String
    let snippet: Snippet
}

struct Snippet: Codable {
    let publishedAt: Date
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let tags: [String]
    let categoryId: String
    let liveBroadcastContent: String
    let localized: Localized
    let defaultAudioLanguage: String
}

struct Thumbnails: Codable {
    let defaultThumbnail: Thumbnail
    let medium: Thumbnail
    let high: Thumbnail
    
    enum CodingKeys: String, CodingKey {
        case defaultThumbnail = "default"
        case medium, high
    }
}

struct Thumbnail: Codable {
    let url: URL
    let width: Int
    let height: Int
}

struct Localized: Codable {
    let title: String
    let description: String
}

struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

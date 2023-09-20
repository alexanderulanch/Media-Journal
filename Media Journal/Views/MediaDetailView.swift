//
//  MediaDetailView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/16/23.
//

import SwiftUI

struct MediaDetailView: View {
    let mediaItem: Media

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ZStack(alignment: .bottomLeading) {
                    if let imageUrl = mediaItem.backdropURL {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                        } placeholder: {
                            Color
                                .secondary
                                .frame(width: 150, height: 100)
                                .cornerRadius(8)
                        }
                    } else {
                        Color
                            .secondary
                            .frame(width: 150, height: 100)
                            .cornerRadius(8)
                    }
                    Text(mediaItem.name ?? mediaItem.title ?? "Unknown Title")
                        .font(.title)
                        .bold()
                        .padding()
                }
                if let imageUrl = mediaItem.posterURL {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                    } placeholder: {
                        Color
                            .secondary
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                    }
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
                } else {
                    Color
                        .secondary
                        .frame(width: 100, height: 150)
                        .cornerRadius(8)
                }

                // Media Overview
                if let overview = mediaItem.overview {
                    Text("Overview: \(overview)")
                        .font(.body)
                }
                
                if let releaseDate = mediaItem.releaseDate {
                    Text("Release Date: \(releaseDate)")
                }
                
                if let firstAirDate = mediaItem.firstAirDate {
                    Text("First Air Date: \(firstAirDate)")
                }
                
                if let originalName = mediaItem.originalName {
                    Text("Original Name: \(originalName)")
                }
                
                // Original Language
                if let originalLanguage = mediaItem.originalLanguage {
                    Text("Language: \(originalLanguage)")
                        .font(.subheadline)
                }

                // Release Date or First Air Date
                Text("Date: \(mediaItem.releaseDate ?? mediaItem.firstAirDate ?? "Unknown")")
                    .font(.subheadline)

                // Popularity
                if let popularity = mediaItem.popularity {
                    Text("Popularity: \(popularity)")
                        .font(.subheadline)
                }

                // Vote Average
                if let voteAverage = mediaItem.voteAverage {
                    Text("Rating: \(voteAverage)/10")
                        .font(.subheadline)
                }

                // Vote Count
                if let voteCount = mediaItem.voteCount {
                    Text("\(voteCount) votes")
                        .font(.subheadline)
                }

                // ... continue for other properties ...

                Spacer()
            }.padding()
        }
    }
}

//#Preview {
//    MediaDetailView(mediaItem: Media.example) // Create an example Media item for preview purposes
//}


//
//  ContentView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/15/23.
//

import SwiftUI

struct ContentView: View {
    @State private var movies: [Media] = []
    @State private var tvShows: [Media] = []
    @State private var query: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search for Movie/Show", text: $query)
                    .textFieldStyle(.roundedBorder)
                
                Button("Search", action: searchAllMediaTypes)
                    .padding(.leading, 10)
            }
            ScrollView {
                MediaSectionView(title: "Movies", media: movies)
                MediaSectionView(title: "TV Shows", media: tvShows)
            }
        }
        .padding()
    }
    
    func searchAllMediaTypes() {
        fetchMedia(mediaType: .movie)
        fetchMedia(mediaType: .tv)
    }
    
    func fetchMedia(mediaType: MediaType) {
        APIManager.shared.searchMedia(query, mediaType: mediaType) { fetchedMediaItems, error in
            if let fetchedMediaItems = fetchedMediaItems {
                switch mediaType {
                case .movie:
                    self.movies = fetchedMediaItems
                case .tv:
                    self.tvShows = fetchedMediaItems
                case .person:
                    return
                }
            } else if let error = error {
                print("Error fetching media: \(error.localizedDescription)")
            }
        }
    }
}

struct MediaSectionView: View {
    var title: String
    var media: [Media]

    var body: some View {
        if !media.isEmpty {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .bold()
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(media) { mediaItem in
                            if let imageUrl = mediaItem.posterURL {
                                AsyncImage(url: imageUrl) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray.frame(width: 100, height: 150)
                                }
                                .frame(width: 100, height: 150)
                                .cornerRadius(8)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

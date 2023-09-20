//
//  SearchView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/16/23.
//

import SwiftUI

struct SearchView: View {
    @State private var movies: [Media] = []
    @State private var tvShows: [Media] = []
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    MediaSectionView(title: "Movies", media: movies)
                    MediaSectionView(title: "TV Shows", media: tvShows)
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Search")
            .toolbarTitleDisplayMode(.inlineLarge)
            .listStyle(.plain)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Shows, Movies, Games and More")
        .onChange(of: searchText) { oldValue, newValue in
            
            if !newValue.isEmpty {
                fetchMedia(mediaType: .movie)
                fetchMedia(mediaType: .tv)
            } else {
                movies = []
                tvShows = []
            }
        }
    }
    
    func fetchMedia(mediaType: MediaType) {
        APIManager.shared.searchMedia(searchText, mediaType: mediaType) { fetchedMediaItems, error in
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
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.title3)
                    .bold()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        ForEach(media) { mediaItem in
                            NavigationLink(destination: MediaDetailView(mediaItem: mediaItem)) {
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
                            }
                        }
                    }
                }
            }
            .safeAreaPadding(.horizontal)
        }
    }
}


#Preview {
    SearchView()
}

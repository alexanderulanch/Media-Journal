//
//  SearchView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/16/23.
//

import SwiftUI

struct SearchView: View {
    @State private var movieResults: [Movie] = []
    @State private var tvShowResults: [TV] = []
    @State private var query: String = ""
    
    let api = APIManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    ResultsScrollView(title: "Movies", results: movieResults)
//                    ResultsScrollView(title: "TV Shows", results: movieResults)
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Search")
            .toolbarTitleDisplayMode(.inlineLarge)
            .listStyle(.plain)
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Shows, Movies, Games and More")
        .onChange(of: query) { oldValue, newValue in
                if !newValue.isEmpty {
                    populateResults(searchType: .movie)
                    populateResults(searchType: .tvShow)
                } else {
                    movieResults = []
                    tvShowResults = []
                }
        }
    }
    
    private func populateResults(searchType: SearchType) {
        switch searchType {
        case .movie:
            api.searchMovie(query) { result, error in
                if let result = result {
                    movieResults = result.results
                } else if let error = error {
                    print("Error searching movies: \(error.localizedDescription)")
                }
            }
        case .tvShow:
            api.searchTV(query) { result, error in
                if let result = result {
                    tvShowResults = result.results
                } else if let error = error {
                    print("Error searching TV shows: \(error.localizedDescription)")
                }
            }
        default:
            return
        }
    }
}

struct ResultsScrollView: View {
    var title: String
    var results: [Movie]
    
    var body: some View {
        if !results.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.title3)
                    .bold()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        ForEach(results) { result in
                            NavigationLink(destination: MovieDetailView(movie: result)) {
                                if let imageUrl = result.posterURL {
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

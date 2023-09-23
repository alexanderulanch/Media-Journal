//
//  SearchView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/16/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm = SearchViewModel()
    @State private var query: String = ""

    
    let api = Network.shared
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    ForEach(Array(vm.searchTypes), id: \.self) { searchType in
                        if let result = vm.searchResults[searchType] {
                            ResultsScrollView(title: searchType.rawValue, response: result)
                        }
                    }
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
                vm.search(query: newValue)
            } else {
                vm.searchResults = [:]
            }
        }
    }
}

struct ResultsScrollView: View {
    var title: String
    var response: SearchResponse
    
    var body: some View {
        if !response.results.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.title3)
                    .bold()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        ForEach(response.results) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                if let imageUrl = movie.posterURL ?? movie.logoURL {
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

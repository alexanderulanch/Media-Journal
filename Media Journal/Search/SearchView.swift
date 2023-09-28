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
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    ForEach(Array(vm.searchResults.keys), id: \.self) { key in
                        if let response = vm.searchResults[key] {
                            ResultsScrollView(title: key, response: response)
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
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Movies, Shows, Games and More")
        .onChange(of: query) { oldValue, newValue in
            vm.search(query: newValue, searchTypes: [.movie(newValue)])
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
                        ForEach(response.results) { mediaItem in
                            if let title = mediaItem.title ?? mediaItem.name {
                                NavigationLink(destination: MovieView(id: mediaItem.id ?? 0)) {
                                    if let imageURL = mediaItem.posterURL {
                                        AsyncImage(url: imageURL) { image in
                                            image.resizable()
                                        } placeholder: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .foregroundStyle(Material.ultraThin)
                                                        .frame(width: 100, height: 150)
                                                    Text(title)
                                                        .foregroundStyle(Color.secondary)
                                                        .font(.headline)
                                                        .bold()
                                                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                                        .padding()
                                                        .frame(width: 100, height: 150)
                                                }
                                        }
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(8)
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(Material.ultraThin)
                                                .frame(width: 100, height: 150)
                                            Text(title)
                                                .foregroundStyle(Color.secondary)
                                                .font(.headline)
                                                .bold()
                                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                                .padding()
                                                .frame(width: 100, height: 150)
                                        }
                                    }
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

//
//  SearchViewModel.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/21/23.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchResults: [SearchType: SearchResponse] = [:]
    @Published var searchTypes: [SearchType] = [.movie, .tvShow, .collection]

    let network = Network.shared

    func search(query: String) {
        searchTypes.forEach { searchType in
            var components = URLComponents(string: searchType.endpoint.urlPath)!
            components.addQueryItem("query", query)
            for (key, value) in searchType.endpoint.parameters {
                components.addQueryItem(key, value)
            }

            guard let url = components.url else {
                print("Invalid URL for searchType \(searchType.rawValue)")
                return
            }

            network.request(url: url, headers: searchType.endpoint.headers) { (result: Result<SearchResponse, Error>) in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.searchResults[searchType] = response
                    }
                case .failure(let error):
                    print("Error searching for \(searchType.rawValue): \(error.localizedDescription)")
                }
            }
        }
    }
}

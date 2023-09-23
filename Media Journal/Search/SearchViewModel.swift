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
            populateResults(query, searchType: searchType)
        }
    }

    private func populateResults(_ query: String, searchType: SearchType) {
        network.search(query, endpoint: searchType.endpoint) { (result: Result<SearchResponse, Error>) in
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

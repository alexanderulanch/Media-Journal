//
//  SearchViewModel.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/21/23.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    @Published var searchResults: [String: SearchResponse] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    private let dataProvider = DataProvider.shared
    
    func search(query: String, searchTypes: [SearchType]) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        if query.isEmpty {
            searchResults = [:]
            return
        }

        searchTypes.forEach { searchType in
            dataProvider.search(query: query, for: searchType)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error searching for \(searchType.description): \(error.localizedDescription)")
                    }
                }, receiveValue: { response in
                    self.searchResults[searchType.description] = response
                })
                .store(in: &cancellables)
        }
    }
}

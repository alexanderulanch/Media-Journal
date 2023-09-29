//
//  MovieViewModel.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/23/23.
//

import Foundation
import UIKit
import Combine

class MovieViewModel: ObservableObject {
    
    @Published var movie: Movie? = nil
    {
        didSet {
            if let backdropURL = movie?.details?.backdropURL {
                loadImage(forKey: "backdrop", from: backdropURL)
            }
            
            if let posterURL = movie?.details?.posterURL {
                loadImage(forKey: "poster", from: posterURL)
            }
        }
    }
    @Published var images: [String: UIImage?] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    private let dataProvider = DataProvider.shared
    
    func getMovie(_ id: Int) {
        dataProvider.fetchMovieDetails(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching movie details: \(error.localizedDescription)")
                }
            }, receiveValue: { movie in
                self.movie = movie
            })
            .store(in: &cancellables)
    }
    
    func loadImage(forKey key: String, from url: URL) {
        dataProvider.fetchImage(from: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.images[key] = image
            })
            .store(in: &cancellables)
    }
        
    func image(forKey key: String) -> UIImage? {
        return images[key] ?? nil
    }
}


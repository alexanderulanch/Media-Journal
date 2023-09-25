//
//  MovieViewModel.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/23/23.
//

import Foundation

class MovieViewModel: ObservableObject {
    @Published var movie: Movie? = nil
    @Published var credits: Credits? = nil
    
    private let network = Network.shared
    
    func getMovie(_ id: Int) {
        getCredits(id)
        guard var components = URLComponents(string: TMDBEndpoint.movie.urlPath + "/\(String(id))") else {
            print("Error: Failed to create URL components from \(TMDBEndpoint.movie.urlPath)")
            return
        }
        for (key, value) in TMDBEndpoint.movie.parameters {
            components.addQueryItem(key, value)
        }
        
        guard let url = components.url else {
            print("Invalid URL for Movie")
            return
        }
        
        network.request(url: url, headers: TMDBEndpoint.movie.headers) { (result: Result<Movie, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.movie = response
                }
            case .failure(let error):
                print("Error searching for Movie: \(error.localizedDescription)")
            }
        }
    }
    
    func getCredits(_ id: Int) {
        guard var components = URLComponents(string: TMDBEndpoint.credits.urlPath + "/\(String(id))/credits") else {
            print("Error: Failed to create URL components from \(TMDBEndpoint.credits.urlPath)")
            return
        }
        for (key, value) in TMDBEndpoint.credits.parameters {
            components.addQueryItem(key, value)
        }
        
        guard let url = components.url else {
            print("Invalid URL for Credits")
            return
        }
        
        network.request(url: url, headers: TMDBEndpoint.credits.headers) { (result: Result<Credits, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.credits = response
                }
            case .failure(let error):
                print("Error searching for Credits: \(error.localizedDescription)")
            }
        }
    }
}

//
//  DataProvider.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/27/23.
//

import Foundation
import UIKit
import Combine

class DataProvider {
    
    static let shared = DataProvider()
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func fetchMovieDetails(id: Int) -> AnyPublisher<(Movie, [YoutubeVideo]), Error> {
        let (detailsModel,
             creditsModel,
             releaseDatesModel,
             videosModel): (Network.RequestModel, Network.RequestModel, Network.RequestModel, Network.RequestModel)
            
        do {
            detailsModel = try createModel(for: TMDBEndpoint.movieDetails(id))
            creditsModel = try createModel(for: TMDBEndpoint.credits(id))
            releaseDatesModel = try createModel(for: TMDBEndpoint.releaseDates(id))
            videosModel = try createModel(for: TMDBEndpoint.movieVideos(id))
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return Publishers.Zip4(
                Network.shared.request(with: creditsModel),
                Network.shared.request(with: detailsModel),
                Network.shared.request(with: releaseDatesModel),
                Network.shared.request(with: videosModel)
            )
            .flatMap { (credits: Credits, details: MovieDetails, releaseDates: ReleaseDateResponse, videos: VideoResponse) -> AnyPublisher<(Movie, [YoutubeVideo]), Error> in
                let movie = Movie(id: id, credits: credits, details: details, releaseDates: releaseDates.results, videos: videos.results)
                
                let youtubeKeys = movie.videos?.filter { $0.site == "YouTube" }.map { $0.key } ?? []
                let videoPublishers = youtubeKeys.map { self.fetchYoutubeVideo(from: $0) }
                
                return Publishers.MergeMany(videoPublishers)
                    .collect()
                    .map { videos -> (Movie, [YoutubeVideo]) in
                        return (movie, videos.flatMap { $0.items })
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func search(query: String, for type: SearchType) -> AnyPublisher<SearchResponse, Error> {
        var searchModel: Network.RequestModel
        
        do {
            searchModel = try createModel(for: type.endpoint)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return Network.shared.request(with: searchModel)
    }
    
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ -> UIImage? in
                return UIImage(data: data)
            }
            .catch { _ in
                Just(nil)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchYoutubeVideo(from id: String) -> AnyPublisher<YoutubeVideoResponse, Error> {
        let youtubeVideoModel: Network.RequestModel
        
        do {
            youtubeVideoModel = try createModel(for: YoutubeEndpoint.youtubeVideo(id))
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return Network.shared.request(with: youtubeVideoModel)
    }
    
    private func createModel(for endpoint: Endpoint) throws -> Network.RequestModel {
        guard var components = URLComponents(string: endpoint.urlPath) else {
            throw DataProviderError.invalidURLComponents(endpoint.urlPath)
        }
        
        for (key, value) in endpoint.parameters {
            components.addQueryItem(key, value)
        }
        
        guard let url = components.url else {
            throw DataProviderError.invalidURL(endpoint.urlPath)
        }
        
        return Network.RequestModel(url: url, headers: endpoint.headers, method: .get)
    }

}

enum DataProviderError: Error {
    case invalidURLComponents(String)
    case invalidURL(String)
}



//
//  Network.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/15/23.
//
import Foundation

class Network {
    static let shared = Network()
    
    private init() {}

    private func request<T: Decodable>(url: URL, headers: Headers, completion: @escaping (Result<T, Error>) -> Void) {
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid data"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(T.self, from: data)
                completion(.success(responseData))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        dataTask.resume()
    }
    
    func search<T: Decodable>(_ query: String,
                              endpoint: Endpoint,
                              completion: @escaping (Result<T, Error>) -> Void) {

        var components = URLComponents(string: endpoint.urlPath)!
        components.addQueryItem("query", query)
        for (key, value) in endpoint.parameters {
            components.addQueryItem(key, value)
        }

        guard let url = components.url else {
            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(urlError))
            return
        }

        request(url: url, headers: endpoint.headers, completion: completion)
    }
}

//import Foundation
//
//class Network {
//    static let shared = Network()
//    private let baseURL = "https://api.themoviedb.org/3/"
//    private var apiToken: String?
//    private let headers: [String: String]
//    
//    private init() {
//        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
//            apiToken = token
//            headers = [
//                "accept": "application/json",
//                "Authorization": "Bearer \(token)"
//            ]
//        } else {
//            fatalError("API_TOKEN not found in Info.plist")
//        }
//    }
//    
//    private func request<T: Decodable>(to url: URL, completion: @escaping (Result<T, Error>) -> Void) {
//        
//        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//        
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid data"])
//                completion(.failure(noDataError))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let responseData = try decoder.decode(T.self, from: data)
//                completion(.success(responseData))
//            } catch let decodeError {
//                completion(.failure(decodeError))
//            }
//        }
//        dataTask.resume()
//    }
//    
//    func searchCollection(_ query: String,
//                          includeAdult: Bool = false,
//                          language: String = "en-US",
//                          page: Int = 1,
//                          region: String? = nil,
//                          completion: @escaping (Result<SearchResponse<Collection>, Error>) -> Void) {
//        
//        var components = URLComponents(string: "\(baseURL)search/collection")!
//        
//        components.addQueryItem("query", query)
//        components.addQueryItem("include_adult", includeAdult)
//        components.addQueryItem("language", language)
//        components.addQueryItem("page", page)
//        components.addQueryItem("region", region)
//        
//        guard let url = components.url else {
//            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//            completion(.failure(urlError))
//            return
//        }
//        
//        request(to: url, completion: completion)
//    }
//    
//    func searchCompany(_ query: String,
//                       page: Int = 1,
//                       completion: @escaping (Result<SearchResponse<Company>, Error>) -> Void) {
//        
//        var components = URLComponents(string: "\(baseURL)search/company")!
//        
//        components.addQueryItem("query", query)
//        components.addQueryItem("page", page)
//        
//        guard let url = components.url else {
//            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//            completion(.failure(urlError))
//            return
//        }
//        
//        request(to: url, completion: completion)
//    }
//
//    func searchMovie(_ query: String,
//                     includeAdult: Bool = false,
//                     language: String = "en-US",
//                     primaryReleaseYear: Int? = nil,
//                     page: Int = 1,
//                     region: String? = nil,
//                     year: Int? = nil,
//                     completion: @escaping (Result<SearchResponse<Movie>, Error>) -> Void) {
//        
//        var components = URLComponents(string: "\(baseURL)search/movie")!
//        
//        components.addQueryItem("query", query)
//        components.addQueryItem("include_adult", includeAdult)
//        components.addQueryItem("language", language)
//        components.addQueryItem("primary_release_year", primaryReleaseYear)
//        components.addQueryItem("page", page)
//        components.addQueryItem("region", region)
//        components.addQueryItem("year", year)
//        
//        guard let url = components.url else {
//                let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
//            completion(.failure(urlError))
//                return
//            }
//            
//        request(to: url, completion: completion)
//    }
//    
//    func searchMulti(_ query: String,
//                    includeAdult: Bool = false,
//                    language: String = "en-US",
//                    page: Int = 1,
//                    completion: @escaping (Result<SearchResponse<Multi>, Error>) -> Void) {
//        
//        var components = URLComponents(string: "\(baseURL)search/multi")!
//        
//        components.addQueryItem("query", query)
//        components.addQueryItem("include_adult", includeAdult)
//        components.addQueryItem("language", language)
//        components.addQueryItem("page", page)
//        
//        guard let url = components.url else {
//                let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
//            completion(.failure(urlError))
//                return
//            }
//            
//        request(to: url, completion: completion)
//    }
//    
//    func searchPerson(_ query: String,
//                      includeAdult: Bool = false,
//                      language: String = "en-US",
//                      page: Int = 1,
//                      completion: @escaping (Result<SearchResponse<Person>, Error>) -> Void) {
//        
//        var components = URLComponents(string: "\(baseURL)search/person")!
//        
//        components.addQueryItem("query", query)
//        components.addQueryItem("include_adult", includeAdult)
//        components.addQueryItem("language", language)
//        components.addQueryItem("page", page)
//        
//        guard let url = components.url else {
//            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//            completion(.failure(urlError))
//            return
//        }
//        
//        request(to: url, completion: completion)
//    }
//
//    func searchTV(_ query: String,
//                    firstAirDateYear: Int? = nil,
//                    includeAdult: Bool = false,
//                    language: String = "en-US",
//                    page: Int = 1,
//                    year: Int? = nil,
//                    completion: @escaping (Result<SearchResponse<TV>, Error>) -> Void) {
//        
//        var components = URLComponents(string: "\(baseURL)search/tv")!
//        
//        components.addQueryItem("query", query)
//        components.addQueryItem("first_air_date_year", firstAirDateYear)
//        components.addQueryItem("include_adult", includeAdult)
//        components.addQueryItem("language", language)
//        components.addQueryItem("page", page)
//        components.addQueryItem("year", year)
//        
//        guard let url = components.url else {
//                let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
//            completion(.failure(urlError))
//                return
//            }
//            
//        request(to: url, completion: completion)
//    }
//}

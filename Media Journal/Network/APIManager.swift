//
//  APIManager.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/15/23.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://api.themoviedb.org/3/"
    private var apiToken: String?
    private let headers: [String: String]
    
    private init() {
        if let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String {
            apiToken = token
            headers = [
                "accept": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        } else {
            fatalError("API_TOKEN not found in Info.plist")
        }
    }
    
    private func sendRequest<T: Decodable>(to url: URL, completion: @escaping (T?, Error?) -> Void) {
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid data"])
                completion(nil, noDataError)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(T.self, from: data)
                completion(responseData, nil)
            } catch let decodeError {
                completion(nil, decodeError)
            }
        }
        dataTask.resume()
    }
    
    func searchCollection(_ query: String,
                          includeAdult: Bool = false,
                          language: String = "en-US",
                          page: Int = 1,
                          region: String? = nil,
                          completion: @escaping (SearchResponse<Collection>?, Error?) -> Void) {
        
        var components = URLComponents(string: "\(baseURL)search/collection")!
        
        components.addQueryItem("query", query)
        components.addQueryItem("include_adult", includeAdult)
        components.addQueryItem("language", language)
        components.addQueryItem("page", page)
        components.addQueryItem("region", region)
        
        guard let url = components.url else {
            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, urlError)
            return
        }
        
        sendRequest(to: url, completion: completion)
    }
    
    func searchCompany(_ query: String,
                       page: Int = 1,
                       completion: @escaping (SearchResponse<Company>?, Error?) -> Void) {
        
        var components = URLComponents(string: "\(baseURL)search/company")!
        
        components.addQueryItem("query", query)
        components.addQueryItem("page", page)
        
        guard let url = components.url else {
            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, urlError)
            return
        }
        
        sendRequest(to: url, completion: completion)
    }

    func searchMovie(_ query: String,
                     includeAdult: Bool = false,
                     language: String = "en-US",
                     primaryReleaseYear: Int? = nil,
                     page: Int = 1,
                     region: String? = nil,
                     year: Int? = nil,
                     completion: @escaping (SearchResponse<Movie>?, Error?) -> Void) {
        
        var components = URLComponents(string: "\(baseURL)search/movie")!
        
        components.addQueryItem("query", query)
        components.addQueryItem("include_adult", includeAdult)
        components.addQueryItem("language", language)
        components.addQueryItem("primary_release_year", primaryReleaseYear)
        components.addQueryItem("page", page)
        components.addQueryItem("region", region)
        components.addQueryItem("year", year)
        
        guard let url = components.url else {
                let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
                completion(nil, urlError)
                return
            }
            
        sendRequest(to: url, completion: completion)
    }
    
    func searchMulti(_ query: String,
                    includeAdult: Bool = false,
                    language: String = "en-US",
                    page: Int = 1,
                    completion: @escaping (SearchResponse<Multi>?, Error?) -> Void) {
        
        var components = URLComponents(string: "\(baseURL)search/multi")!
        
        components.addQueryItem("query", query)
        components.addQueryItem("include_adult", includeAdult)
        components.addQueryItem("language", language)
        components.addQueryItem("page", page)
        
        guard let url = components.url else {
                let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
                completion(nil, urlError)
                return
            }
            
        sendRequest(to: url, completion: completion)
    }
    
    func searchPerson(_ query: String,
                      includeAdult: Bool = false,
                      language: String = "en-US",
                      page: Int = 1,
                      completion: @escaping (SearchResponse<Person>?, Error?) -> Void) {
        
        var components = URLComponents(string: "\(baseURL)search/person")!
        
        components.addQueryItem("query", query)
        components.addQueryItem("include_adult", includeAdult)
        components.addQueryItem("language", language)
        components.addQueryItem("page", page)
        
        guard let url = components.url else {
            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, urlError)
            return
        }
        
        sendRequest(to: url, completion: completion)
    }

    func searchTV(_ query: String,
                    firstAirDateYear: Int? = nil,
                    includeAdult: Bool = false,
                    language: String = "en-US",
                    page: Int = 1,
                    year: Int? = nil,
                    completion: @escaping (SearchResponse<TV>?, Error?) -> Void) {
        
        var components = URLComponents(string: "\(baseURL)search/tv")!
        
        components.addQueryItem("query", query)
        components.addQueryItem("first_air_date_year", firstAirDateYear)
        components.addQueryItem("include_adult", includeAdult)
        components.addQueryItem("language", language)
        components.addQueryItem("page", page)
        components.addQueryItem("year", year)
        
        guard let url = components.url else {
                let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
                completion(nil, urlError)
                return
            }
            
        sendRequest(to: url, completion: completion)
    }
}

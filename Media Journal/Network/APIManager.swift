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
    
    func searchMedia(_ query: String, mediaType: MediaType, completion: @escaping ([Media]?, Error?) -> Void) {
        
        let endpoint: String
        switch mediaType {
        case .movie:
            endpoint = "movie"
        case .tv:
            endpoint = "tv"
        case .person:
            endpoint = "people"
        }
        
        let urlString = "\(baseURL)search/\(endpoint)?query=\(query)&include_adult=false&language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
            completion(nil, urlError)
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // Printing the full request for debugging
        print("Request: \(request)")
        print("Headers: \(headers)")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Received error: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid data"])
                print("No data received from server.")
                completion(nil, noDataError)
                return
            }
            
            // Printing the received data as a string for debugging
            if let receivedDataString = String(data: data, encoding: .utf8) {
                print("Received data: \(receivedDataString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                print("Decoded response: \(searchResponse)")
                completion(searchResponse.results, nil)
            } catch let decodeError {
                print("Error decoding response: \(decodeError)")
                completion(nil, decodeError)
            }
        }
        dataTask.resume()
    }
}
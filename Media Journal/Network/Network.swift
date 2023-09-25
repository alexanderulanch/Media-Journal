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

    func request<T: Codable>(url: URL, headers: Headers, completion: @escaping (Result<T, Error>) -> Void) {
        
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
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseData = try decoder.decode(T.self, from: data)
                completion(.success(responseData))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        
        dataTask.resume()
    }
}

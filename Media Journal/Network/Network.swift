//
//  Network.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/15/23.
//

import Foundation
import Combine

class Network {
    static let shared = Network()
    
    private init() {}

    func request<T: Decodable>(with model: RequestModel) -> AnyPublisher<T, Error> {
        
        var request = URLRequest(url: model.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = model.method.rawValue
        request.allHTTPHeaderFields = model.headers
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder().convertFromSnakeCaseDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    struct RequestModel {
        let url: URL
        let headers: [String: String]
        let method: HTTPMethods
    }
    
    enum HTTPMethods: String {
        case get = "GET"
    }
}

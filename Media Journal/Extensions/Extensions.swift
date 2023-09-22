//
//  Extensions.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/20/23.
//

import Foundation

extension URLComponents {
    mutating func addQueryItem<T>(_ name: String, _ value: T?) {
        if let value = value {
            let stringValue = String(describing: value)
            let queryItem = URLQueryItem(name: name, value: stringValue)
            if self.queryItems == nil {
                self.queryItems = [queryItem]
            } else {
                self.queryItems?.append(queryItem)
            }
        }
    }
}

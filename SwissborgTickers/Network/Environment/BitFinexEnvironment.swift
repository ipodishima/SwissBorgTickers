//
//  BitFinexEnvironment.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-17.
//

import Foundation

/// Represents the API environment
enum BitFinexEnvironment {
    case production
    
    var baseURL: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = version.prefixIfNeeded(with: "/")
        
        guard let url = urlComponents.url else {
            fatalError("The URL is not valid")
        }
        return url
    }
    
    private var host: String {
        let host: String
        switch self {
        case .production:
            host = "api-pub.bitfinex.com"
        }
        return host
    }
    
    private var scheme: String {
        "https"
    }
    
    private var version: String {
        "v2"
    }
}

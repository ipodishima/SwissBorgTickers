//
//  BitFinexEnvironment.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-17.
//

import Foundation

enum BitFinexEnvironment {
    case production
    
    var baseURL: URL {
        let host: String
        switch self {
        case .production:
            host = "api-pub.bitfinex.com"
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = version.prefixIfNeeded(with: "/")
        
        guard let url = urlComponents.url else {
            fatalError("The URL is not valid")
        }
        return url
    }
    
    private var scheme: String {
        "https"
    }
    
    private var version: String {
        "v2"
    }
}

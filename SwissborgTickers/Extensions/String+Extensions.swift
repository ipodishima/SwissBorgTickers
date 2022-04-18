//
//  String+Extensions.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-17.
//

import Foundation

extension String {
    
    /// Prefix a string with the prefix if not already prefixed
    /// - Parameter prefix: The prefix to put first
    /// - Returns: Self if the prefix is already part of self, prefix+self otherwise
    func prefixIfNeeded(with prefix: String) -> String {
        guard !hasPrefix(prefix) else {
            return self
        }
        return prefix + self
    }
    
}

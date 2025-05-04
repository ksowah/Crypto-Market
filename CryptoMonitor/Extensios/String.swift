//
//  String.swift
//  CryptoMonitor
//
//  Created by macbook on 03/05/2025.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}

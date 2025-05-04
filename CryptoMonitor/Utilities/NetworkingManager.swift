//
//  NetworkingManager.swift
//  CryptoMonitor
//
//  Created by macbook on 27/04/2025.
//

import Foundation
import SwiftUI

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unkown error occured"
            }
        }
    }
    
    static func download<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkingError.badURLResponse(url: url)
        }
        
        let decoder = JSONDecoder()
        
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }
    
    static func downloadImage(url: URL) async throws -> UIImage? {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return image
    }
}

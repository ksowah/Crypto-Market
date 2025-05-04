//
//  MarketDataService.swift
//  CryptoMonitor
//
//  Created by macbook on 28/04/2025.
//

import Foundation

class MarketDataService {
    @Published var marketData: MarketDataModel? = nil
    
    init() {
        Task {
            try await getData()
        }
    }
    
    func getData() async throws -> () {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        
        do {
            let globalData: GlobalData = try await NetworkingManager.download(url: url)
            DispatchQueue.main.async { [weak self] in
                self?.marketData = globalData.data
            }
         } catch {
             print("Error fetching coins: \(error.localizedDescription)")
         }
    }
}

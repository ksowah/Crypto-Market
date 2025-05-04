//
//  CoinDataService.swift
//  CryptoMonitor
//
//  Created by macbook on 27/04/2025.
//

import Foundation

class CoinDataService {
    @Published var allCoins: [CoinModel] = []
    
    init() {
        Task {
            try await getCoins()
        }
    }
    
    func getCoins() async throws -> () {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        
        do {
            let coins: [CoinModel] = try await NetworkingManager.download(url: url)
            DispatchQueue.main.async { [weak self] in
                self?.allCoins = coins
            }
         } catch {
             print("Error fetching coins: \(error.localizedDescription)")
         }
    }
}

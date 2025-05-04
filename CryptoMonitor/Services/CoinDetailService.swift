//
//  CoinDetailService.swift
//  CryptoMonitor
//
//  Created by macbook on 03/05/2025.
//

import Foundation

class CoinDetailDataService {
    @Published var coinDetail: CoinDetailModel? = nil
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        Task {
            try await getCoinDetails()
        }
    }
    
    func getCoinDetails() async throws -> () {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false") else {return}
        
        do {
            let coin: CoinDetailModel = try await NetworkingManager.download(url: url)
            DispatchQueue.main.async { [weak self] in
                self?.coinDetail = coin
            }
         } catch {
             print("Error fetching coin details: \(error.localizedDescription)")
         }
    }
}

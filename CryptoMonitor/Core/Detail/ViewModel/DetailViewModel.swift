//
//  DetailViewModel.swift
//  CryptoMonitor
//
//  Created by macbook on 03/05/2025.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coin: CoinModel
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetail
            .combineLatest($coin)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(mapDataToStatistics)
            .sink { [weak self] statistics in
                self?.overviewStatistics = statistics.overview
                self?.additionalStatistics = statistics.additional
            }
            .store(in: &cancellables)
        
        coinDetailDataService.$coinDetail
            .sink { [weak self](returnedCoinDetail) in
                self?.coinDescription = returnedCoinDetail?.readableDescription
                self?.websiteURL = returnedCoinDetail?.links?.homepage?.first
                self?.redditURL = returnedCoinDetail?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetail: CoinDetailModel?, coin: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        let overview: [StatisticModel] = [
            .init(title: "Current Price", value: coin.currentPrice.asCurrencyWith6Decimals(), percentageChange: coin.priceChangePercentage24H),
            .init(title: "Market Capitalization", value: "$" + (coin.marketCap?.formattedWithAbbreviations() ?? ""), percentageChange: coin.marketCapChangePercentage24H),
            .init(title: "Rank", value: "\(coin.rank)"),
            .init(title: "Volume", value: "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? ""))
        ]
        
        let additional: [StatisticModel] = [
            .init(title: "24h High", value: coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"),
            .init(title: "24h Low", value: coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"),
            .init(title: "24h Price Change", value: coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a", percentageChange: coin.priceChangePercentage24H),
            .init(title: "24h Market Cap Change", value: "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? ""), percentageChange: coin.marketCapChangePercentage24H),
            .init(title: "Block Time", value: (coinDetail?.blockTimeInMinutes == 0 ? "n/a" : "\(coinDetail?.blockTimeInMinutes ?? 0)")),
            .init(title: "Hashing Algorithm", value: coinDetail?.hashingAlgorithm ?? "n/a")
        ]
        
        return (overview, additional)
    }
}

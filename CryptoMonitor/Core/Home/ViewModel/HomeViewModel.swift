//
//  HomeViewModel.swift
//  CryptoMonitor
//
//  Created by macbook on 27/04/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init () {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map{ (text, startingCoins) -> [CoinModel] in
                guard !text.isEmpty else {
                    return startingCoins
                }
                
                let lowercasedText = text.lowercased()
                
                let filteredCoins =  startingCoins.filter { coin in
                    return coin.name.lowercased().contains(lowercasedText) ||
                            coin.symbol.lowercased().contains(lowercasedText) ||
                            coin.id.lowercased().contains(lowercasedText)
                }
                
                return filteredCoins
            }
            .sink { [weak self] (coins) in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map { (marketDataModel, portfolioCoins) -> [StatisticModel] in
                var stats: [StatisticModel] = []
                
                guard let data = marketDataModel else {
                    return stats
                }
                
                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = StatisticModel(title: "24h Volume", value: data.volume)
                let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDomiance)
                
                let portfolioValue = portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +)
                
                let previousValue = portfolioCoins.map { (coin) -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                    let previousValue = currentValue / (1 + percentChange)
                    return previousValue
                }
                    .reduce(0, +)
                
                let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
                
                let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)

                
                stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
                
                return stats
            }
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntity) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntity.first(where: {$0.coinID == coin.id}) else {return nil}
                        
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() async {
        do {
            try await coinDataService.getCoins()
            try await marketDataService.getData()
            HapticManager.notification(type: .success)
        } catch let error {
            print("Error reloading data: \(error)")
        }
    }
}

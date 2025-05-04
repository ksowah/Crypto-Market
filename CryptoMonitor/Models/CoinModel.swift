//
//  CoinModel.swift
//  CryptoMonitor
//
//  Created by macbook on 27/04/2025.
//

//Coin Gecko API Reference

/*
 const url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h';
 const options = {
   method: 'GET',
   headers: {accept: 'application/json', 'x-cg-demo-api-key': 'CG-srFMQTGz6TtPBQx7chfThLQk'}
 };
 
 
 
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
     "current_price": 93921,
     "market_cap": 1864959154869,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 1864959154869,
     "total_volume": 15402998086,
     "high_24h": 95115,
     "low_24h": 93879,
     "price_change_24h": -287.08957323133654,
     "price_change_percentage_24h": -0.30474,
     "market_cap_change_24h": -5465796364.477783,
     "market_cap_change_percentage_24h": -0.29222,
     "circulating_supply": 19856762,
     "total_supply": 19856762,
     "max_supply": 21000000,
     "ath": 108786,
     "ath_change_percentage": -13.60398,
     "ath_date": "2025-01-20T09:11:54.494Z",
     "atl": 67.81,
     "atl_change_percentage": 138504.56681,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2025-04-27T12:11:45.991Z",
     "sparkline_in_7d": {
       "price": [
         84093.83367559967,
         84347.36438378347,
         94186.57489664084,
         94077.48711673608, ....
       ]
     },
     "price_change_percentage_24h_in_currency": -0.3047411001507139
   },
 
 */

import Foundation

struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        return (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}

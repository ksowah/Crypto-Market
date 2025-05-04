//
//  CoinImageViewModel.swift
//  CryptoMonitor
//
//  Created by macbook on 27/04/2025.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let coin: CoinModel
    private let dataService: CoinImageService
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.getImage()
        self.isLoading = true
    }
    
    private func getImage() {
        dataService.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
        
        self.isLoading = false
    }
}

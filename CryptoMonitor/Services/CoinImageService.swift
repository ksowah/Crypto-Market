//
//  CoinImageService.swift
//  CryptoMonitor
//
//  Created by macbook on 27/04/2025.
//

import Foundation
import SwiftUI

class CoinImageService {
    
    @Published var image: UIImage?
    private let fileManager = LocalFileManager.instance
    private let coin: CoinModel
    private let imageName: String
    private let folderName: String = "coin_images"
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        Task {
            await getCoinImage()
        }
    }
    
    private func getCoinImage() async {
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedImage
        } else {
            do {
                try await downloadCoinImage()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func downloadCoinImage() async throws {
        guard let url = URL(string: coin.image) else {return}
        
        do {
            if let image = try await NetworkingManager.downloadImage(url: url) {
                self.fileManager.saveImage(image: image, imageName: self.imageName, folderName: self.folderName)
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            }
         } catch {
             print("Error downloading Imagge: \(error.localizedDescription)")
         }
    }
}

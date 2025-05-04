//
//  UIApplication.swift
//  CryptoMonitor
//
//  Created by macbook on 28/04/2025.
//

import Foundation
import SwiftUI


extension UIApplication {
    func endEditting() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

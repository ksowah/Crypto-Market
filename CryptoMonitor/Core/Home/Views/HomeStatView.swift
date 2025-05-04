//
//  HomeStatView.swift
//  CryptoMonitor
//
//  Created by macbook on 28/04/2025.
//

import SwiftUI

struct HomeStatView: View {    
    @Binding var showPortfolio: Bool
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}

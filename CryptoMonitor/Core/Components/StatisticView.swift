//
//  StatisticView.swift
//  CryptoMonitor
//
//  Created by macbook on 28/04/2025.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
                
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? .theme.green : .theme.red)
            .opacity(stat.percentageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.stat1)
                .preferredColorScheme(.dark)
            StatisticView(stat: dev.stat2)
            StatisticView(stat: dev.stat3)
                .preferredColorScheme(.dark)
        }
    }
}

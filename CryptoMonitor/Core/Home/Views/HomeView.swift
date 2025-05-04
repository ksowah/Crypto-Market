//
//  HomeView.swift
//  CryptoMonitor
//
//  Created by macbook on 26/04/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio: Bool = false // for animate
    @State private var showPortfolioView: Bool = false // for sheet
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            VStack {
                header
                
                HomeStatView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                            
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                HomeView()
            }
            .environmentObject(dev.homeVM)
            
            NavigationStack {
                HomeView()
            }
            .preferredColorScheme(.dark)
            .environmentObject(dev.homeVM)
            
        }
    }
}


extension HomeView {
    private var header: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus": "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .animation(.none)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 00))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                NavigationLink {
                    DetailsView(coin: coin)
                } label: {
                    CoinRowView(coin: coin, showHoldingColumn: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            Task {
                await vm.reloadData()
            }
        }
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                NavigationLink {
                    DetailsView(coin: coin)
                } label: {
                    CoinRowView(coin: coin, showHoldingColumn: true)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
                
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holding")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }

}

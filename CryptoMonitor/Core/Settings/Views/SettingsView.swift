//
//  SettingsView.swift
//  CryptoMonitor
//
//  Created by macbook on 03/05/2025.
//

import SwiftUI

struct SettingsView: View {
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com")!
    let portfolio = URL(string: "https://www.ksowah.netlify.app")!
    let github = URL(string: "https://www.github.com/ksowah")!
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } header: {
                    Text("Crypto Market")
                }

            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

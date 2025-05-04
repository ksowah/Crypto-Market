//
//  XMarkButton.swift
//  CryptoMonitor
//
//  Created by macbook on 28/04/2025.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}

//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Nick Coleman on 10/22/25.
//

import SwiftUI

struct QuoteView: View {
    let vm = ViewModel()
    
    var body: some View {
        TabView {
            Tab("Breaking Bad", systemImage: "tortoise") {
                Text("Breaking Bad View")
            }
            Tab("Better Call Saul", systemImage: "briefcase") {
                Text("Better Call Saul View")
            }
        }
        .preferredColorScheme(.dark)
        .tint(.orange)
    }
}

#Preview {
    QuoteView()
        .preferredColorScheme(.dark)
}

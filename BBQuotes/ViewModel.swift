//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Nick Coleman on 10/26/25.
//

import Foundation

@Observable // means views can react to changes in its properties
@MainActor // ensures all its code runs on the main thread
class ViewModel {
    enum fetchStatus {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    // Property to track fetch status
    // private(set) means only ViewModel can change it.  But views can read it (get).
    private(set) var status: fetchStatus = .notStarted
    
    // Initialize Fetch Service
    private let fetcher = FetchService()
    
    // Properties to hold quotes, deaths, and characters
    var quote: Quote
    var character: Char
    
    init () { // class requires initial values for its properties
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(
            contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!
        )
        quote = try! decoder.decode(Quote.self, from: quoteData)
        
        
        let characterData = try! Data(
            contentsOf: Bundle.main.url(forResource: "samplechar", withExtension: "json")!
        )
        character = try! decoder.decode(Char.self, from: characterData)
    }
    
    // Function runs when user taps "Get Random Quote" button
    func getData (for show: String) async {
        status = .fetching
        
        do {
            // Fetch a random quote
            quote = try await fetcher.fetchQuote(from: show)
            
            // Fetch character details
            character = try await fetcher.fetchCharacter(quote.character)
            
            character.death = try await fetcher.fetchDeath(for: character.name)
            
            status = .success
        } catch {
            status = .failed(error: error)
        }

    }
    
}

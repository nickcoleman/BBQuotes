//
//  FetchService.swift
//  BBQuotes
//
//  Created by Nick Coleman on 10/23/25.
//
import Foundation

struct FetchService {
    // Swift
    private enum FetchError: Error {
        case badResponse
        case invalidURL
        case requestFailed(Error)            // underlying network error (URLError, etc.)
        case httpError(statusCode: Int)      // non-2xx HTTP status
        case noData                           // e.g., 204 No Content when body expected
        case decodingFailed(Error)           // decoding error with underlying Error
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")
    
    func fetchQuote(from show: String) async throws -> Quote {
        // Construct the fetch URL
        let quoteURL = baseURL!.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
                
        // Fetch the data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // Handle response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // Decode the data
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        
        // Return the quote
        return quote
    }
    
    func fetchCharacter(_ name: String) async throws -> Char {
        // Construct the fetch URL
        let charURL = baseURL!.appending(path: "characters")
        let fetchURL = charURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        
        // Fetch the data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // Handle response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // Decode the data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let characters = try decoder.decode([Char].self, from: data)
        
        return characters[0]
    }
    
    func fetchDeath(for character: String) async throws -> Death? {
        
        // Construct the fetch URL
        let fetchURL = baseURL!.appending(path: "deaths")
        
        // Fetch the data -- data may contain an empty array if no death info
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // Handle response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // Decode the data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let deaths = try decoder.decode([Death].self, from: data)
        
        
        // find death for character - alternative using first(where:)
//        guard let death = deaths.first(where: { $0.character == character }) else {
//            return nil
//        }
        
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        
        return nil
    }

}

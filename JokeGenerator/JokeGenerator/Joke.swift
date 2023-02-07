//
//  Joke.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/6/23.
//

import Foundation

/*
 
 JSON from endpoint:
 {
    id: 1,
    type: "Random",
    setup: "What's a cow's favorite sound?",
    punchline: "Moo-sic"
 }
 
 */

struct Joke: Codable, Identifiable {
    var id: Int
    var type: String
    var setup: String
    var punchline: String
    
    static func getJoke() async throws -> Joke {
        guard var url = URL(string: "https://official-joke-api.appspot.com") else {
            throw URLError(.badURL)
        }
        url.append(path: "random_joke")
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(Joke.self, from: data)
        
        return decoded
    }
    
    static func getJokes() async throws -> [Joke] {
        guard var url = URL(string: "https://official-joke-api.appspot.com") else {
            throw URLError(.badURL)
        }
        url.append(path: "random_ten")
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode([Joke].self, from: data)
        
        return decoded
    }
}

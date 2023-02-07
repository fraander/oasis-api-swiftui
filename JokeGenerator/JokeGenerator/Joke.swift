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
    
    static func getJoke() async -> Joke? {
        guard var url = URL(string: "https://official-joke-api.appspot.com") else {
            return nil
        }
        url.append(path: "random_joke")
        
        let request = URLRequest(url: url)
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            print("Did not receive response.")
            return nil
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        
        guard let decoded = try? JSONDecoder().decode(Joke.self, from: data) else {
            print("Cannot decode.")
            return nil
        }
        
        return decoded
    }
}

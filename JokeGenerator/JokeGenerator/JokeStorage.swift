//
//  JokeStorage.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/7/23.
//

import Foundation

extension String: Error {}

class JokeStorage: ObservableObject {
    @Published var storedJokes: [Joke] {
        didSet {
            try? writeToDocuments()
        }
    }
    
    init() {
        storedJokes = []
        if let j = try? readFromDocuments() {
            storedJokes = j
        }
    }
    
    func readFromDocuments() throws -> [Joke] {
        let url = getJokesURL()
        
        let fm = FileManager()
        guard let data = fm.contents(atPath: url.path) else {
            throw "Error reading data at path."
        }
        
        return try JSONDecoder().decode([Joke].self, from: data)
    }
    
    func writeToDocuments() throws {
        guard let json = try? JSONEncoder().encode(storedJokes) else {
            throw "Cannot encode joke"
        }
        let url = getJokesURL()
        
        do {
            try json.write(to: url)
        } catch {
            throw "Could not write to documents"
        }
    }
    
    func getJokesURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("jokes.json")
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}

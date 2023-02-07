//
//  JokesListView.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/7/23.
//

import SwiftUI

struct JokesListView: View {
    
    @State var jokes: [Joke] = []
    
    var body: some View {
        VStack {
            List(jokes) { joke in
                VStack(alignment: .leading) {
                    Text(joke.setup)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Text(joke.punchline)
                        .font(.system(.subheadline, design: .rounded, weight: .regular))
                }
            }
            .refreshable {
                Task {
                    let newJokes = try await Joke.getJokes()
                    jokes = newJokes + jokes
                }
            }
        }
        .task {
            Task {
                jokes = try await Joke.getJokes()
            }
        }
    }
}

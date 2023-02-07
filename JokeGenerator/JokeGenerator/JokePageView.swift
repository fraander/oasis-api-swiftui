//
//  JokePageView.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/7/23.
//

import SwiftUI

struct JokesPageView: View {
    
    @State var jokes: [Joke] = []
    @State var selection: Int?
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(jokes) { joke in
                ScrollView {
                    VStack  {
                        Spacer()
                            .frame(height: 250)
                        
                        JokeViewListWrapper(joke: joke)
                            .padding()
                            .tag(joke.id)
                        
                        Spacer()
                    }
                }
                .refreshable {
                    Task {
                        let newJokes = try await Joke.getJokes()
                        jokes = newJokes + jokes
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .task {
            Task {
                jokes = try await Joke.getJokes()
            }
        }
    }
}

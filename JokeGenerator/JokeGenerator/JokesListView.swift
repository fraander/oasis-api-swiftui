//
//  JokesListView.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/7/23.
//

import SwiftUI

struct JokeViewListWrapper: View {
    @State var showPunchline = false
    let joke: Joke
    
    var body: some View {
        JokeView(loading: .constant(false), showPunchline: $showPunchline, joke: joke)
    }
}

struct JokesListView: View {
    
    @ObservedObject var storage = JokeStorage()
    @State var jokes: [Joke] = []
    @State var saved: Bool = true
    
    var listView: some View {
        List(jokes) { joke in
            JokeViewListWrapper(joke: joke)
                .padding()
                .swipeActions {
                    Button {
                        storage.storeJoke(joke: joke)
                    } label: {
                        Label("Save", systemImage: "star.fill")
                    }
                    .tint(.yellow)
                    
                }
        }
        .refreshable {
            Task {
                let newJokes = try await Joke.getJokes()
                jokes = newJokes + jokes
            }
        }
        
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if jokes.isEmpty {
                    LoadingIndicator(loading: .constant(true))
                } else {
                    listView
                }
            }
            
            .sheet(isPresented: $saved) {
                JokesPageView()
            }
            .task {
                Task {
                    jokes = try await Joke.getJokes()
                }
            }
            .toolbar {
                Button {
                    saved.toggle()
                } label: {
                    Label("Saved", systemImage: "tray.full")
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.bordered)
                .tint(.orange)
            }
        }
    }
}

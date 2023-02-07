//
//  ContentView.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/6/23.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var joke: Joke? = nil
    @Published var loading: Bool = false
    @Published var showPunchline: Bool = false
    
    var hasJoke: Bool {
        return joke == nil
    }
    
    func requestJoke() {
        loading = true
        showPunchline = false
        
        DispatchQueue.main.async {
            Task {
                self.joke = try await Joke.getJoke()
                self.loading = false
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var vm: ContentViewModel = .init()
    
    var body: some View {
        VStack {
            if let j = vm.joke {
                Spacer()
                JokeView(loading: $vm.loading, showPunchline: $vm.showPunchline, joke: j)
                    .transition(.scale)
                Spacer()
            }
            
            Button {
                vm.requestJoke()
            } label: {
                Label("Get Joke", systemImage: "theatermask.and.paintbrush.fill")
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            
        }
        .animation(.easeInOut, value: vm.hasJoke)
        .padding()
        .overlay {
            LoadingIndicator(loading: $vm.loading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

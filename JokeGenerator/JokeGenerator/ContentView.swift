//
//  ContentView.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/6/23.
//

import SwiftUI

struct Joke: Codable, Identifiable {
    var id: Int
    var type: String
    var setup: String
    var punchline: String
}

struct ContentView: View {
    
    @State var joke: Joke? = nil
    @State var loading: Bool = false
    @State var showPunchline: Bool = false
    
    var hasJoke: Bool {
        return joke == nil
    }
    
    var body: some View {
        VStack {
            if let j = joke {
                Spacer()
                
                GroupBox {
                    Text(j.setup)
                        .bold()
                        .padding(20)
                    
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.orange)
                        .frame(height: 120)
                        .overlay {
                            if showPunchline {
                                Text(j.punchline)
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding(20)
                            } else {
                                Label("Show Punchline", systemImage: "eye.fill")
                                    .tint(.white)
                            }
                        }
                        .onTapGesture {
                            showPunchline.toggle()
                        }
                }
                .transition(.scale)
                
                Spacer()
            }
            
            
            Button {
                requestJoke()
            } label: {
                Label("Get Joke", systemImage: "theatermask.and.paintbrush.fill")
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            
        }
        .animation(.easeInOut, value: hasJoke)
        .padding()
        .overlay {
            if loading {
                ProgressView()
                    .padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
            }
        }
    }
    
    func requestJoke() {
        loading = true
        showPunchline = false
        joke = nil
        Task {
            joke = await getJoke()
            loading = false
        }
    }
    
    func getJoke() async -> Joke? {
        guard var url = URL(string: "https://official-joke-api.appspot.com") else {
            print("Invalid URL")
            return nil
        }
        url.append(path: "random_joke")
        print("url:", url)
        
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  JokeView.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/6/23.
//

import SwiftUI

struct JokeView: View {
    
    @Binding var loading: Bool
    @Binding var showPunchline: Bool
    let joke: Joke
    
    var setupText: some View {
        Text(joke.setup)
            .bold()
            .padding(20)
    }
    
    var showPunchlineButton: some View {
        Group {
            if showPunchline {
                Text(joke.punchline)
                    .padding(20)
            } else {
                Label("Show Punchline", systemImage: "eye.fill")
            }
        }
    }
    
    var body: some View {
        VStack {
            if loading {
                setupText
                    .redacted(reason: .placeholder)
            } else {
                setupText
            }
            
            Button {
                showPunchline.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.orange)
                    .frame(height: 120)
                    .overlay {
                        if loading {
                            showPunchlineButton
                                .redacted(reason: .placeholder)
                        } else {
                            showPunchlineButton
                        }
                    }
                    .foregroundColor(.white)
                    .bold()
            }
            .buttonStyle(.plain)
        }
    }
}

struct JokeView_Previews: PreviewProvider {
    static var previews: some View {
        JokeView(loading: .constant(true), showPunchline: .constant(true), joke: Joke(id: 1, type: "Random", setup: "What's the deal with shrimp fried rice?", punchline: "You're telling me a shrimp fried this rice!?"))
            .previewLayout(.sizeThatFits)
    }
}

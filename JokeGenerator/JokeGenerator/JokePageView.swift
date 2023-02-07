//
//  JokePageView.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/7/23.
//

import SwiftUI

struct JokesPageView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storage: JokeStorage = .init()
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(0..<storage.storedJokes.count, id: \.self) { index in
                VStack  {
                    
                    Spacer()
                        .frame(height: 250)
                    
                    JokeViewListWrapper(joke: storage.storedJokes[index])
                        .padding()
                        .tag(index)
                    
                    Spacer()
                    
                    Button {
                        storage.removeJoke(index: index)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                    .tint(.pink)
                    
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay {
            VStack {
                HStack {
                    Button {
                        //
                    } label: {
                        Text("\(storage.storedJokes.count == 0 ? 0 : selection + 1) / \(storage.storedJokes.count)")
                    }
                    .allowsHitTesting(false)
                    .buttonStyle(.bordered)
                    .tint(.orange)

                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                    }
                    .buttonStyle(.bordered)
                    .tint(.orange)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

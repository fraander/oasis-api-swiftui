//
//  LoadingIndicator.swift
//  JokeGenerator
//
//  Created by Frank Anderson on 2/6/23.
//

import SwiftUI

struct LoadingIndicator: View {
    @Binding var loading: Bool
    
    var body: some View {
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

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator(loading: .constant(false))
        LoadingIndicator(loading: .constant(true))
    }
}

//
//  Indicator.swift
//  RecipeBook
//
//  Created by AnhDuc on 12/05/2024.
//

import SwiftUI

struct Indicator: View {

    @State var animateTrimPath = false
    @State var rotaeInfinity = false

    var body: some View {

        ZStack {
            Color.black
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                .scaleEffect(2.0, anchor: .center)  // Makes the spinner larger
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        // Simulates a delay in content loading
                        // Perform transition to the next view here
                    }
                }
        }
    }
}

#Preview {
    Indicator()
}

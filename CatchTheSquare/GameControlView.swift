//
//  ContentView.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct GameControlView: View {
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            // How To Play
            Text("\(.init(systemName: "eye")) \(.init(systemName: "arrow.forward")) \(.init(systemName: "cursor.rays")) \(.init(systemName: "arrow.forward")) \( .init(systemName: "rectangle.inset.filled.and.cursorarrow"))")
                .font(.largeTitle)
            
            Button(game.running ? "Stop" : "Start", action: {
                if game.running {
                    game.handleGameOver()
                } else {
                    game.start()
                }
            })
            .font(.largeTitle)
            .padding()
        }
        .padding()
        .sheet(isPresented: $game.showScoreView) {
            ScoreView(game: game)
        }
    }
}

#Preview(windowStyle: .automatic) {
    GameControlView(game: Game())
}

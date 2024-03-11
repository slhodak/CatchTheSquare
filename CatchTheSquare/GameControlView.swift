//
//  ContentView.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct GameControlWindow: View {
    @ObservedObject var game: Game
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    var body: some View {
        VStack {
            // How To Play
            Text("\(.init(systemName: "eye")) \(.init(systemName: "arrow.forward")) \(.init(systemName: "cursor.rays")) \(.init(systemName: "arrow.forward")) \( .init(systemName: "rectangle.inset.filled.and.cursorarrow"))")
                .font(.largeTitle)
            
            Button(game.gridIsShown ? "Reset" : "Show Game", action: {
                dismissWindow(id: "GameVolume")
                openWindow(id: "GameVolume")
            })
            .font(.largeTitle)
            .padding()
            
            Button(game.running ? "Stop" : "Start Game", action: {
                game.running ? game.stop() : game.start()
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
 
//#Preview(windowStyle: .automatic) {
//    GamecontrolWindow(game: Game())
//}

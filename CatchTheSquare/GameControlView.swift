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
    @Binding var isOpen: Bool
    @Binding var gameVolumeIsOpen: Bool
    
    var body: some View {
        VStack {
            // How To Play
            Text("\(.init(systemName: "eye")) \(.init(systemName: "arrow.forward")) \(.init(systemName: "cursor.rays")) \(.init(systemName: "arrow.forward")) \( .init(systemName: "rectangle.inset.filled.and.cursorarrow"))")
                .font(.largeTitle)
            
            Toggle(isOn: $gameVolumeIsOpen) {
                Text("Show Game Grid")
            }
            .onChange(of: gameVolumeIsOpen) {
                gameVolumeIsOpen == true ? openWindow(id: "GameVolume") : dismissWindow(id: "GameVolume")
            }
            .font(.largeTitle)
            .padding()
            
            Button(game.running ? "Stop" : "Start Game", action: {
                game.running ? game.handleGameOver() : game.start()
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

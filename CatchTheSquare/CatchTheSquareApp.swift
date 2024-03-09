//
//  CatchTheSquareApp.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/8/24.
//

import SwiftUI
import RealityKitContent


@main
struct CatchTheSquareApp: App {
    @ObservedObject var game = Game()
    let windowHeight = 0.2
    let goldenRatio = 1.618
    
    init() {
        SquareIdentifierComponent.registerComponent()
    }
    
    var body: some Scene {
        WindowGroup {
            GameView(game: game)
        }.windowStyle(.volumetric)
        
        WindowGroup(id: "GameControlWindow") {
            GameControlView(game: game)
                .padding()
        }
        .defaultSize(width: windowHeight * goldenRatio, height: windowHeight, depth: 0.02, in: .meters)
    }
}

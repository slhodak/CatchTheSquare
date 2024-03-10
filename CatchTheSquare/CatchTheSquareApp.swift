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
    
    @State var controlWindowIsOpen: Bool = false
    @State var gameVolumeIsOpen: Bool = false
    
    init() {
        SquareIdentifierComponent.registerComponent()
    }
    
    var body: some Scene {
        WindowGroup(id: "GameControlWindow") {
            GameControlWindow(game: game,
                              isOpen: $controlWindowIsOpen,
                              gameVolumeIsOpen: $gameVolumeIsOpen)
                .padding()
        }
        .defaultSize(width: windowHeight * goldenRatio,
                     height: windowHeight,
                     depth: 0.02,
                     in: .meters)
        
        WindowGroup(id: "GameVolume") {
            GameView(game: game,
                     isOpen: $gameVolumeIsOpen,
                     controlWindowIsOpen: $controlWindowIsOpen)
        }
        .windowStyle(.volumetric)
    }
}

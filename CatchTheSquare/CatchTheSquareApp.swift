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
    let windowHeight = 0.2
    let goldenRatio = 1.618
    
    init() {
        SquareIdentifierComponent.registerComponent()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: windowHeight * goldenRatio, height: windowHeight, depth: 0.02, in: .meters)

        ImmersiveSpace(id: "GameSpace") {
            GameView()
        }
    }
}

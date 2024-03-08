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
    
    init() {
        SquareIdentifierComponent.registerComponent()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "GameSpace") {
            GameView()
        }
    }
}

//
//  ImmersiveView.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct GameView: View {
    @ObservedObject var game: Game
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        RealityView { content in
            game.setup(content: content)
            openWindow(id: "GameControlWindow")
        }
        .gesture(spatialTapToAny)
    }
    
    var spatialTapToAny: some Gesture {
        SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                guard let squareModel = value.entity.findEntity(named: "SquareModel") as? ModelEntity else {
                    print("No SquareModel found on entity \(value.entity)")
                    return
                }
                
                if let squareIdentifier = squareModel.components[SquareIdentifierComponent.self] {
                    game.handleClick(row: squareIdentifier.row, column: squareIdentifier.column)
                } else {
                    print("Could not get identifier on square")
                }
            }
    }
}

#Preview {
    GameView(game: Game())
        .previewLayout(.sizeThatFits)
}

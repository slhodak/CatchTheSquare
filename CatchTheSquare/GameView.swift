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
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        RealityView { content, attachments in
            game.setup(content: content)
            
            if let controlsAttachment = attachments.entity(for: "OpenControls") {
                controlsAttachment.position.y = -0.45
                controlsAttachment.position.z = 0.2
                controlsAttachment.orientation = simd_quatf(angle: -15 * Float.pi / 180, axis: [1, 0, 0])
                content.add(controlsAttachment)
            }
        } attachments: {
            Attachment(id: "OpenControls") {
                Button("Show Menu", action: {
                    dismissWindow(id: "GameControlWindow")
                    openWindow(id: "GameControlWindow")
                })
                .glassBackgroundEffect()
                .font(.largeTitle)
                .padding()
            }
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

//#Preview {
//    GameView(game: Game())
//        .previewLayout(.sizeThatFits)
//}

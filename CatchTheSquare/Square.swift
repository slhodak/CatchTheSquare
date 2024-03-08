//
//  GridPlane.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent


class Square {
    static let targetMaterial = SimpleMaterial(color: .orange, roughness: 0.5, isMetallic: false)
    static let clickedMaterial = UnlitMaterial(color: .white)
    static let basicMaterial = SimpleMaterial(color: .green, roughness: 0.5, isMetallic: false)
    
    var model: ModelEntity
    
    var isTarget: Bool = false {
        didSet {
            model.model?.materials = isTarget ? [Self.targetMaterial] : [Self.basicMaterial]
        }
    }
    
    init(size: Float, row: Int, column: Int) {
        let mesh = MeshResource.generatePlane(width: size, height: size)
        let model = ModelEntity(mesh: mesh, materials: [Self.basicMaterial])
        model.components.set(CollisionComponent(shapes: [.generateBox(width: size, height: size, depth: size * 0.1)]))
        model.components.set(HoverEffectComponent())
        model.components.set(InputTargetComponent())
        model.components.set(SquareIdentifierComponent(row: row, column: column))
        model.name = "SquareModel"
        self.model = model
    }
    
    func handleClick() {
        model.model?.materials = [Self.clickedMaterial]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.model.model?.materials = [Self.basicMaterial]
        }
    }
}

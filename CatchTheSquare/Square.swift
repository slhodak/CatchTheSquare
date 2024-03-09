//
//  GridPlane.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent


class Square: Hashable {
    static let targetMaterial = SimpleMaterial(color: .orange, roughness: 0.5, isMetallic: false)
    static let clickedMaterial = UnlitMaterial(color: .white)
    static let basicMaterial = SimpleMaterial(color: .cyan, roughness: 0.5, isMetallic: false)
    static let lockedMaterial = SimpleMaterial(color: .red, roughness: 0.5, isMetallic: false)
    
    var model: ModelEntity
    let row: Int
    let column: Int
    
    var isClicked: Bool = false
    var isLocked: Bool = false
    var isTarget: Bool = false {
        didSet {
            model.model?.materials = isTarget ? [Self.targetMaterial] : [Self.basicMaterial]
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
    
    static func == (lhs: Square, rhs: Square) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    init(size: Float, row: Int, column: Int) {
        let mesh = MeshResource.generateBox(width: size, height: size, depth: size * 0.1, cornerRadius: 0.05)
        let model = ModelEntity(mesh: mesh, materials: [Self.basicMaterial])
        model.components.set(CollisionComponent(shapes: [.generateBox(width: size, height: size, depth: size * 0.1)]))
        model.components.set(HoverEffectComponent())
        model.components.set(InputTargetComponent())
        model.components.set(SquareIdentifierComponent(row: row, column: column))
        model.name = "SquareModel"
        
        self.model = model
        self.row = row
        self.column = column
    }
    
    func handleClick() {
        isClicked = true
        model.model?.materials = [Self.clickedMaterial]
        
        if isTarget {
            model.removeFromParent()
        } else {
            isLocked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.model.model?.materials = [Self.lockedMaterial]
            }
        }
    }
}

//
//  Game.swift
//  CatchTheSquare
//
//  Created by Sam Hodak on 3/8/24.
//

import SwiftUI
import RealityKit


class Game: ObservableObject {
    @Published var grid = [Int: [Int: Square]]()
    @Published var rootEntity = Entity()
    var target: Square?
    var timer: Timer?
    
    let gridX = 10
    let gridY = 10
    let gridSpacing: Float = 0.06
    let squareSize: Float = 0.05
    
    init() {
        self.timer = Timer.scheduledTimer(timeInterval: 3,
                                          target: self,
                                          selector: #selector(setTarget),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    func setup(content: RealityViewContent) {
        rootEntity.position.x = -0.5
        rootEntity.position.z = -1.5
        rootEntity.position.y = 1
        initGrid()
        content.add(rootEntity)
    }
    
    private func initGrid() {
        for i in 0...gridX {
            var row = [Int: Square]()
            for j in 0...gridY {
                let gridPlane = Square(size: squareSize, row: i, column: j)
                gridPlane.model.position.x = Float(i) * gridSpacing
                gridPlane.model.position.y = Float(j) * gridSpacing
                row[j] = gridPlane
                rootEntity.addChild(gridPlane.model)
            }
            
            self.grid[i] = row
        }
    }
    
    func handleClick(row i: Int, column j: Int) {
        guard let row = grid[i] else {
            print("No row at \(i)")
            print(grid)
            return
        }
        
        guard j < row.count else {
            print("Invalid column value: \(j) outside range")
            return
        }
        
        guard let square = row[j] else {
            print("No square at \(i),\(j)")
            return
        }
        
        square.handleClick()
    }
    
    @objc func setTarget() {
        if let target = target {
            target.isTarget = false
        }
        
        let randomX = Int.random(in: 0..<gridX)
        let randomY = Int.random(in: 0..<gridY)
        if let row = grid[randomX],
           let square = row[randomY] {
            square.isTarget = true
            target = square
        }
    }
}

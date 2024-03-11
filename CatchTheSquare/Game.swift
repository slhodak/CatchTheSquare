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
    @Published var showScoreView: Bool = false
    var realityViewContent: RealityViewContent?
    var freeSquares = Set<Square>()
    var target: Square?
    var setTargetAfter: TimeInterval = 3.0
    var running = false
    var score = Score()
    
    let gridX = 10
    let gridY = 10
    let gridSpacing: Float = 0.06
    let squareSize: Float = 0.05
    
    func setup(content: RealityViewContent) {
        rootEntity.position.x = (Float(gridX) * gridSpacing) / 2 * -1
        rootEntity.position.z = 0
        rootEntity.position.y = (Float(gridY) * gridSpacing) / 2 * -1
        realityViewContent = content
        content.add(rootEntity)
        initGrid()
    }
    
    func erase() {
        for (_, row) in grid {
            for (_, square) in row {
                square.model.removeFromParent()
                freeSquares.remove(square)
            }
        }
        
        realityViewContent?.remove(rootEntity)
    }
    
    func start() {
        reset()
        running = true
        startTimer()
    }
    
    func reset() {
        running = false
        erase()
        initGrid()
        realityViewContent?.add(rootEntity)
    }
    
    private func initGrid() {
        for i in 0..<gridX {
            var row = [Int: Square]()
            for j in 0..<gridY {
                let square = Square(size: squareSize, row: i, column: j)
                square.model.position.x = Float(i) * gridSpacing
                square.model.position.y = Float(j) * gridSpacing
                row[j] = square
                freeSquares.insert(square)
                rootEntity.addChild(square.model)
            }
            
            self.grid[i] = row
        }
    }
    
    func handleClick(row i: Int, column j: Int) {
        guard let square = getClickedSquare(row: i, column: j) else { return }
        
        freeSquares.remove(square)
        
        square.click()
        if square.isTarget {
            square.remove()
            setTargetAfter = setTargetAfter * 0.98
            score.hit += 1
        } else {
            square.lock()
            score.wrong += 1
        }
        
        // Check end condition
        if freeSquares.isEmpty || setTargetAfter <= 0.25 {
            handleGameOver()
        }
    }
    
    private func getClickedSquare(row i: Int, column j: Int) -> Square? {
        guard let row = grid[i] else {
            print("No row at \(i)")
            return nil
        }
        
        guard j < row.count else {
            print("Invalid column value: \(j) outside range")
            return nil
        }
        
        guard let square = row[j] else {
            print("No square at \(i),\(j)")
            return nil
        }
        
        return square
    }
    
    private func startTimer() {
        guard running else { return }
        
        setTarget()
        DispatchQueue.main.asyncAfter(deadline: .now() + setTargetAfter) {
            self.startTimer()
        }
    }
    
    private func setTarget() {
        if let target = target {
            if !target.isClicked {
                score.missed += 1
            }
            target.isTarget = false
        }
        
        if let square = freeSquares.randomElement() {
            
            square.isTarget = true
            target = square
        }
    }
    
    func handleGameOver() {
        running = false
        self.showScoreView = true
    }
}

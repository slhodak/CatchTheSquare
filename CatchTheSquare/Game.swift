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
    var freeSquares = Set<Square>()
    var target: Square?
    var setTargetAfter: TimeInterval = 3.0
    var running = true
    var score = Score() // find a way to publish this
    
    let gridX = 10
    let gridY = 10
    let gridSpacing: Float = 0.06
    let squareSize: Float = 0.05
    
    init() {
        startTimer()
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
        guard var row = grid[i] else {
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
        freeSquares.remove(square)
        
        if square.isTarget {
            row[j] = nil
            score.hit += 1
            setTargetAfter = setTargetAfter * 0.98
        } else {
            score.wrong += 1
        }
        
        // Check end condition
        if freeSquares.isEmpty ||
            setTargetAfter <= 0.25 {
            handleGameOver()
        }
    }
    
    func startTimer() {
        guard running else { return }
        
        setTarget()
        DispatchQueue.main.asyncAfter(deadline: .now() + setTargetAfter) {
            self.startTimer()
        }
    }
    
    func setTarget() {
        if let target = target {
            if !target.isClicked {
                score.missed += 1
//                target.lock(afterDelay: false)
//                freeSquares.remove(target)
            }
            target.isTarget = false
        }
        
        if let square = freeSquares.randomElement() {
            
            square.isTarget = true
            target = square
        }
    }
    
    func handleGameOver() {
        print("Game Over!")
        running = false
        print(score)
    }
}

class Score {
    var hit: Int = 0
    var wrong: Int = 0
    var missed: Int = 0
}

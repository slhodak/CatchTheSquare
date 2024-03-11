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
    @Published var running = false
    @Published var gridIsShown = false
    
    var realityViewContent: RealityViewContent?
    var freeSquares = Set<Square>()
    var target: Square?
    var setTargetAfter: TimeInterval = 3.0
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
        realityViewContent?.add(rootEntity)
        initGrid()
        print("Storing RealityViewContent on Game")
    }
    
    func start() {
        running = true
        startTimer()
    }
    
    func stop() {
        running = false
        self.showScoreView = true
        reset()
    }
    
    func reset() {
        running = false
        eraseGrid()
        initGrid()
    }
    
    private func initGrid() {
        print("creating grid")
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
        gridIsShown = true
    }
    
    private func eraseGrid() {
        print("erasing grid")
        for (_, row) in grid {
            for (_, square) in row {
                square.model.removeFromParent()
                freeSquares.remove(square)
            }
        }
        grid = [Int:[Int: Square]]()
        gridIsShown = false
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
            stop()
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
}

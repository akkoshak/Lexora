//
//  WordSearchViewModel.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI
import Observation

@Observable class WordSearchViewModel {
    var grid: [[WordSearchCell]] = []
    var placedWords: [PlacedWord] = []
    var selectedCells: [(row: Int, col: Int)] = []
    var foundIndices: Set<Int> = []
    var incorrectCells: [(row: Int, col: Int)] = []
    var isGameComplete: Bool = false
    
    private var lockedDirection: (dRow: Int, dCol: Int)? = nil
    private var dragOriginCell: (row: Int, col: Int)? = nil
    private var dragOriginPoint: CGPoint? = nil
    
    private let engine = WordSearchEngine()
    
    // Minimum pixel distance before locking a direction
    private let lockThreshold: CGFloat = 10
    
    // MARK: - Start Game
    
    func startNewGame() {
        let entries = GlossaryService.shared.entries
        engine.generate(from: entries)
        grid = engine.grid
        placedWords = engine.placedWords
        selectedCells = []
        foundIndices = []
        incorrectCells = []
        isGameComplete = false
        lockedDirection = nil
        dragOriginCell = nil
        dragOriginPoint = nil
    }
    
    // MARK: - Selection
    
    func startSelection(row: Int, col: Int, point: CGPoint) {
        dragOriginCell = (row, col)
        dragOriginPoint = point
        lockedDirection = nil
        selectedCells = [(row, col)]
    }
    
    func updateSelection(currentPoint: CGPoint, cellSize: CGFloat) {
        guard let originPoint = dragOriginPoint,
              let originCell = dragOriginCell else { return }
        
        let dx = currentPoint.x - originPoint.x
        let dy = currentPoint.y - originPoint.y
        let distance = sqrt(dx * dx + dy * dy)
        
        // Don't lock direction until finger has moved enough pixels
        if lockedDirection == nil {
            guard distance >= lockThreshold else { return }
            
            // Determine direction from pixel angle
            let angle = atan2(dy, dx) // radians, -π to π
            let degrees = angle * 180 / .pi
            
            // Snap angle to nearest 45° increment → one of 8 directions
            let snapped = (round(degrees / 45) * 45)
            let dir = directionFromDegrees(snapped)
            lockedDirection = dir
        }
        
        guard let dir = lockedDirection else { return }
        
        // How many steps along the locked direction from origin?
        let steps: Int
        if dir.dRow != 0 && dir.dCol != 0 {
            // Diagonal — use the average of row and col displacement
            let rowSteps = abs(dy / cellSize)
            let colSteps = abs(dx / cellSize)
            steps = Int((rowSteps + colSteps) / 2)
        } else if dir.dRow != 0 {
            steps = Int(abs(dy / cellSize))
        } else {
            steps = Int(abs(dx / cellSize))
        }
        
        // Build selection from origin along locked direction
        var cells: [(row: Int, col: Int)] = []
        for i in 0...steps {
            let r = originCell.row + dir.dRow * i
            let c = originCell.col + dir.dCol * i
            guard r >= 0, r < grid.count, c >= 0, c < grid[0].count else { break }
            cells.append((r, c))
        }
        
        if !cells.isEmpty {
            selectedCells = cells
        }
    }
    
    func commitSelection() {
        defer {
            selectedCells = []
            lockedDirection = nil
            dragOriginCell = nil
            dragOriginPoint = nil
        }
        
        guard selectedCells.count >= 3 else { return }
        
        if let matchIndex = engine.checkSelection(selectedCells) {
            engine.markFound(at: matchIndex)
            foundIndices.insert(matchIndex)
            placedWords = engine.placedWords
            isGameComplete = foundIndices.count == placedWords.count
        } else {
            incorrectCells = selectedCells
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.incorrectCells = []
            }
        }
    }
    
    // MARK: - Cell State
    
    func cellState(row: Int, col: Int) -> CellState {
        if incorrectCells.contains(where: { $0.row == row && $0.col == col }) {
            return .incorrect
        }
        for (i, word) in placedWords.enumerated() where foundIndices.contains(i) {
            if word.cells.contains(where: { $0.row == row && $0.col == col }) {
                return .found
            }
        }
        if selectedCells.contains(where: { $0.row == row && $0.col == col }) {
            return .selected
        }
        return .normal
    }
    
    // MARK: - Direction from angle

    /// Maps a snapped degree value to a (dRow, dCol) direction.
    private func directionFromDegrees(_ degrees: Double) -> (dRow: Int, dCol: Int) {
        switch degrees {
        case 0:          return (0, 1)    // right
        case 45:         return (1, 1)    // down-right
        case 90:         return (1, 0)    // down
        case 135:        return (1, -1)   // down-left
        case 180, -180:  return (0, -1)   // left
        case -135:       return (-1, -1)  // up-left
        case -90:        return (-1, 0)   // up
        case -45:        return (-1, 1)   // up-right
        default:         return (0, 1)
        }
    }
}

// MARK: - Cell State
enum CellState {
    case normal, selected, found, incorrect
}
